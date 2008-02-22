From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Test AES-CCM mode via IPSec (NETKEY)
Date: Fri, 22 Feb 2008 13:45:30 +0800
Message-ID: <E1JSQiw-0002dT-00@gondolin.me.apana.org.au>
References: <006b01c874fa$7428b510$d620420a@amcc.com>
Cc: linux-crypto@vger.kernel.org
To: locnho@sbcglobal.net (Loc Ho)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49641 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYBVFpg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Feb 2008 00:45:36 -0500
In-Reply-To: <006b01c874fa$7428b510$d620420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Loc Ho <locnho@sbcglobal.net> wrote:
> 
> I am trying to test AES-CCM mode via IPSec. Setkey doesn't seem to support
> "aes-ccm" mode. Anyone try this yet? Or should I checkout OpenSwan or
> racoon?

Sorry, I forgot to submit the iproute2 patch for this.

See if this one helps.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/include/linux/xfrm.h b/include/linux/xfrm.h
index 51aa042..b0c4cc8 100644
--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -96,6 +96,13 @@ struct xfrm_algo {
 	char	alg_key[0];
 };
 
+struct xfrm_algo_aead {
+	char	alg_name[64];
+	int	alg_key_len;	/* in bits */
+	int	alg_icv_len;	/* in bits */
+	char	alg_key[0];
+};
+
 struct xfrm_stats {
 	__u32	replay_window;
 	__u32	replay;
@@ -114,6 +121,7 @@ enum
 	XFRM_POLICY_IN	= 0,
 	XFRM_POLICY_OUT	= 1,
 	XFRM_POLICY_FWD	= 2,
+	XFRM_POLICY_MASK = 3,
 	XFRM_POLICY_MAX	= 3
 };
 
@@ -269,6 +277,7 @@ enum xfrm_attr_type_t {
 	XFRMA_LASTUSED,
 	XFRMA_POLICY_TYPE,	/* struct xfrm_userpolicy_type */
 	XFRMA_MIGRATE,
+	XFRMA_ALG_AEAD,		/* struct xfrm_algo_aead */
 	__XFRMA_MAX
 
 #define XFRMA_MAX (__XFRMA_MAX - 1)
@@ -328,6 +337,7 @@ struct xfrm_usersa_info {
 #define XFRM_STATE_DECAP_DSCP	2
 #define XFRM_STATE_NOPMTUDISC	4
 #define XFRM_STATE_WILDRECV	8
+#define XFRM_STATE_ICMP		16
 };
 
 struct xfrm_usersa_id {
@@ -362,6 +372,8 @@ struct xfrm_userpolicy_info {
 #define XFRM_POLICY_BLOCK	1
 	__u8				flags;
 #define XFRM_POLICY_LOCALOK	1	/* Allow user to override global policy */
+	/* Automatically expand selector to include matching ICMP payloads. */
+#define XFRM_POLICY_ICMP	2
 	__u8				share;
 };
 
@@ -414,12 +426,14 @@ struct xfrm_user_migrate {
 	__u16				new_family;
 };
 
+#ifndef __KERNEL__
 /* backwards compatibility for userspace */
 #define XFRMGRP_ACQUIRE		1
 #define XFRMGRP_EXPIRE		2
 #define XFRMGRP_SA		4
 #define XFRMGRP_POLICY		8
 #define XFRMGRP_REPORT		0x20
+#endif
 
 enum xfrm_nlgroups {
 	XFRMNLGRP_NONE,
diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index 80dbb52..0a7d39a 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -154,7 +154,8 @@ const char *strxf_xfrmproto(__u8 proto)
 
 static const struct typeent algo_types[]= {
 	{ "enc", XFRMA_ALG_CRYPT }, { "auth", XFRMA_ALG_AUTH },
-	{ "comp", XFRMA_ALG_COMP }, { NULL, -1 }
+	{ "comp", XFRMA_ALG_COMP }, { "aead", XFRMA_ALG_AEAD },
+	{ NULL, -1 }
 };
 
 int xfrm_algotype_getbyname(char *name)
@@ -525,8 +526,8 @@ void xfrm_selector_print(struct xfrm_selector *sel, __u16 family,
 	fprintf(fp, "%s", _SL_);
 }
 
-static void xfrm_algo_print(struct xfrm_algo *algo, int type, int len,
-			    FILE *fp, const char *prefix)
+static void __xfrm_algo_print(struct xfrm_algo *algo, int type, int len,
+			      FILE *fp, const char *prefix, int newline)
 {
 	int keylen;
 	int i;
@@ -558,6 +559,32 @@ static void xfrm_algo_print(struct xfrm_algo *algo, int type, int len,
 		fprintf(fp, " (%d bits)", algo->alg_key_len);
 
  fin:
+	if (newline)
+		fprintf(fp, "%s", _SL_);
+}
+
+static inline void xfrm_algo_print(struct xfrm_algo *algo, int type, int len,
+				   FILE *fp, const char *prefix)
+{
+	return __xfrm_algo_print(algo, type, len, fp, prefix, 1);
+}
+
+static void xfrm_aead_print(struct xfrm_algo_aead *algo, int len,
+			    FILE *fp, const char *prefix)
+{
+	struct {
+		struct xfrm_algo algo;
+		char key[algo->alg_key_len / 8];
+	} base;
+
+	memcpy(base.algo.alg_name, algo->alg_name, sizeof(base.algo.alg_name));
+	base.algo.alg_key_len = algo->alg_key_len;
+	memcpy(base.algo.alg_key, algo->alg_key, algo->alg_key_len / 8);
+
+	__xfrm_algo_print(&base.algo, XFRMA_ALG_AEAD, len, fp, prefix, 0);
+
+	fprintf(fp, " %d", algo->alg_icv_len);
+
 	fprintf(fp, "%s", _SL_);
 }
 
@@ -635,6 +662,12 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 				XFRMA_ALG_AUTH, RTA_PAYLOAD(rta), fp, prefix);
 	}
 
+	if (tb[XFRMA_ALG_AEAD]) {
+		struct rtattr *rta = tb[XFRMA_ALG_AEAD];
+		xfrm_aead_print((struct xfrm_algo_aead *)RTA_DATA(rta),
+				RTA_PAYLOAD(rta), fp, prefix);
+	}
+
 	if (tb[XFRMA_ALG_CRYPT]) {
 		struct rtattr *rta = tb[XFRMA_ALG_CRYPT];
 		xfrm_algo_print((struct xfrm_algo *) RTA_DATA(rta),
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index f51e8b6..0748a61 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -88,8 +88,10 @@ static void usage(void)
         fprintf(stderr, "ENCAP-TYPE := espinudp | espinudp-nonike\n");
 
 	fprintf(stderr, "ALGO-LIST := [ ALGO-LIST ] | [ ALGO ]\n");
-	fprintf(stderr, "ALGO := ALGO_TYPE ALGO_NAME ALGO_KEY\n");
+	fprintf(stderr, "ALGO := ALGO_TYPE ALGO_NAME ALGO_KEY "
+			"[ ALGO_ICV_LEN ]\n");
 	fprintf(stderr, "ALGO_TYPE := [ ");
+	fprintf(stderr, "%s | ", strxf_algotype(XFRMA_ALG_AEAD));
 	fprintf(stderr, "%s | ", strxf_algotype(XFRMA_ALG_CRYPT));
 	fprintf(stderr, "%s | ", strxf_algotype(XFRMA_ALG_AUTH));
 	fprintf(stderr, "%s ", strxf_algotype(XFRMA_ALG_COMP));
@@ -112,7 +114,7 @@ static void usage(void)
 }
 
 static int xfrm_algo_parse(struct xfrm_algo *alg, enum xfrm_attr_type_t type,
-			   char *name, char *key, int max)
+			   char *name, char *key, char *buf, int max)
 {
 	int len;
 	int slen = strlen(key);
@@ -152,7 +154,7 @@ static int xfrm_algo_parse(struct xfrm_algo *alg, enum xfrm_attr_type_t type,
 			if (get_u8(&val, vbuf, 16))
 				invarg("\"ALGOKEY\" is invalid", key);
 
-			alg->alg_key[j] = val;
+			buf[j] = val;
 		}
 	} else {
 		len = slen;
@@ -160,7 +162,7 @@ static int xfrm_algo_parse(struct xfrm_algo *alg, enum xfrm_attr_type_t type,
 			if (len > max)
 				invarg("\"ALGOKEY\" makes buffer overflow\n", key);
 
-			strncpy(alg->alg_key, key, len);
+			strncpy(buf, key, len);
 		}
 	}
 
@@ -233,6 +235,7 @@ static int xfrm_state_modify(int cmd, unsigned flags, int argc, char **argv)
 		char   			buf[RTA_BUF_SIZE];
 	} req;
 	char *idp = NULL;
+	char *aeadop = NULL;
 	char *ealgop = NULL;
 	char *aalgop = NULL;
 	char *calgop = NULL;
@@ -316,20 +319,31 @@ static int xfrm_state_modify(int cmd, unsigned flags, int argc, char **argv)
 			/* try to assume ALGO */
 			int type = xfrm_algotype_getbyname(*argv);
 			switch (type) {
+			case XFRMA_ALG_AEAD:
 			case XFRMA_ALG_CRYPT:
 			case XFRMA_ALG_AUTH:
 			case XFRMA_ALG_COMP:
 			{
 				/* ALGO */
 				struct {
-					struct xfrm_algo alg;
+					union {
+						struct xfrm_algo alg;
+						struct xfrm_algo_aead aead;
+					} u;
 					char buf[XFRM_ALGO_KEY_BUF_SIZE];
-				} alg;
+				} alg = {};
 				int len;
+				__u32 icvlen;
 				char *name;
 				char *key;
+				char *buf;
 
 				switch (type) {
+				case XFRMA_ALG_AEAD:
+					if (aeadop)
+						duparg("ALGOTYPE", *argv);
+					aeadop = *argv;
+					break;
 				case XFRMA_ALG_CRYPT:
 					if (ealgop)
 						duparg("ALGOTYPE", *argv);
@@ -360,11 +374,27 @@ static int xfrm_state_modify(int cmd, unsigned flags, int argc, char **argv)
 				NEXT_ARG();
 				key = *argv;
 
-				memset(&alg, 0, sizeof(alg));
+				buf = alg.u.alg.alg_key;
+				len = sizeof(alg.u.alg);
+
+				if (type != XFRMA_ALG_AEAD)
+					goto parse_algo;
+
+				if (!NEXT_ARG_OK())
+					missarg("ALGOICVLEN");
+				NEXT_ARG();
+				if (get_u32(&icvlen, *argv, 0))
+					invarg("\"aead\" ICV length is invalid",
+					       *argv);
+				alg.u.aead.alg_icv_len = icvlen;
+
+				buf = alg.u.aead.alg_key;
+				len = sizeof(alg.u.aead);
 
+parse_algo:
 				xfrm_algo_parse((void *)&alg, type, name, key,
-						sizeof(alg.buf));
-				len = sizeof(struct xfrm_algo) + alg.alg.alg_key_len;
+						buf, sizeof(alg.buf));
+				len += alg.u.alg.alg_key_len;
 
 				addattr_l(&req.n, sizeof(req.buf), type,
 					  (void *)&alg, len);
@@ -417,7 +447,7 @@ static int xfrm_state_modify(int cmd, unsigned flags, int argc, char **argv)
 		break;
 	}
 
-	if (ealgop || aalgop || calgop) {
+	if (aeadop || ealgop || aalgop || calgop) {
 		if (!xfrm_xfrmproto_is_ipsec(req.xsinfo.id.proto)) {
 			fprintf(stderr, "\"ALGO\" is invalid with proto=%s\n",
 				strxf_xfrmproto(req.xsinfo.id.proto));
