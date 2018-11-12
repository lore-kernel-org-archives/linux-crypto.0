Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32739 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbeKLUXC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:23:02 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>
Subject: [RFC][PATCH 05/12] PGPLIB: Signature parser
Date: Mon, 12 Nov 2018 11:24:16 +0100
Message-ID: <20181112102423.30415-6-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: David Howells <dhowells@redhat.com>

Provide some PGP signature parsing helpers:

 (1) A function to parse V4 signature subpackets and pass the desired ones
     to a processor function:

	int pgp_parse_sig_subpkts(const u8 *data, size_t datalen,
				  struct pgp_parse_sig_context *ctx);

 (2) A function to parse out basic signature parameters from any PGP
     signature such that the algorithms and public key can be selected:

	int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
				 struct pgp_sig_parameters *p);

Changelog

v0:
- fix style issues (Roberto Sassu)

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/pgp_library.c | 283 ++++++++++++++++++++++++++-
 include/linux/pgplib.h               |  25 +++
 2 files changed, 307 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pgp_library.c b/crypto/asymmetric_keys/pgp_library.c
index 0ab702ffe173..13bfc9db1ae4 100644
--- a/crypto/asymmetric_keys/pgp_library.c
+++ b/crypto/asymmetric_keys/pgp_library.c
@@ -154,7 +154,7 @@ static ssize_t pgp_parse_packet_header(const u8 **_data, size_t *_datalen,
 		}
 	}
 
-	pr_devel("datalen=%zu size=%zu", datalen, size);
+	pr_devel("datalen=%zu size=%zu\n", datalen, size);
 	if (datalen < size)
 		goto short_packet;
 	if ((int)size < 0)
@@ -278,3 +278,284 @@ int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pgp_parse_public_key);
+
+/**
+ * pgp_parse_sig_subpkt_header - Parse a PGP V4 signature subpacket header
+ * @_data: Start of the subpacket (updated to subpacket data)
+ * @_datalen: Amount of data remaining in buffer (decreased)
+ * @_type: Where the subpacket type will be returned
+ *
+ * Parse a PGP V4 signature subpacket header [RFC 4880: 5.2.3.1].
+ *
+ * Returns packet data size on success; non-zero on error.  If successful,
+ * *_data and *_datalen will have been updated and *_headerlen will be set to
+ * hold the length of the packet header.
+ */
+static ssize_t pgp_parse_sig_subpkt_header(const u8 **_data, size_t *_datalen,
+					   enum pgp_sig_subpkt_type *_type)
+{
+	enum pgp_sig_subpkt_type type;
+	const u8 *data = *_data;
+	size_t size, datalen = *_datalen;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 2)
+		goto short_subpacket;
+
+	pr_devel("subpkt hdr %02x, %02x\n", data[0], data[1]);
+
+	switch (data[0]) {
+	case 0x00 ... 0xbf:
+		/* One-byte length */
+		size = data[0];
+		data++;
+		datalen--;
+		break;
+	case 0xc0 ... 0xfe:
+		/* Two-byte length */
+		if (datalen < 3)
+			goto short_subpacket;
+		size = (data[0] - 192) * 256;
+		size += data[1] + 192;
+		data += 2;
+		datalen -= 2;
+		break;
+	case 0xff:
+		if (datalen < 6)
+			goto short_subpacket;
+		size  = data[1] << 24;
+		size |= data[2] << 16;
+		size |= data[3] << 8;
+		size |= data[4];
+		data += 5;
+		datalen -= 5;
+		break;
+	}
+
+	/* The type octet is included in the size */
+	pr_devel("datalen=%zu size=%zu\n", datalen, size);
+	if (datalen < size)
+		goto short_subpacket;
+	if (size == 0)
+		goto very_short_subpacket;
+	if ((int)size < 0)
+		goto too_big;
+
+	type = *data++ & ~PGP_SIG_SUBPKT_TYPE_CRITICAL_MASK;
+	datalen--;
+	size--;
+
+	*_data = data;
+	*_datalen = datalen;
+	*_type = type;
+	pr_devel("Found subpkt type=%u size=%zd\n", type, size);
+	return size;
+
+very_short_subpacket:
+	pr_debug("Signature subpacket size can't be zero\n");
+	return -EBADMSG;
+short_subpacket:
+	pr_debug("Attempt to parse short signature subpacket\n");
+	return -EBADMSG;
+too_big:
+	pr_debug("Signature subpacket size >2G\n");
+	return -EMSGSIZE;
+}
+
+/**
+ * pgp_parse_sig_subpkts - Parse a set of PGP V4 signatute subpackets
+ * @_data: Data to be parsed (updated)
+ * @_datalen: Amount of data (updated)
+ * @ctx: Parsing context
+ *
+ * Parse a set of PGP signature subpackets [RFC 4880: 5.2.3].
+ */
+static int pgp_parse_sig_subpkts(const u8 *data, size_t datalen,
+				 struct pgp_parse_sig_context *ctx)
+{
+	enum pgp_sig_subpkt_type type;
+	ssize_t pktlen;
+	int ret;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	while (datalen > 2) {
+		pktlen = pgp_parse_sig_subpkt_header(&data, &datalen, &type);
+		if (pktlen < 0)
+			return pktlen;
+		if (test_bit(type, ctx->types_of_interest)) {
+			ret = ctx->process_packet(ctx, type, data, pktlen);
+			if (ret < 0)
+				return ret;
+		}
+		data += pktlen;
+		datalen -= pktlen;
+	}
+
+	if (datalen != 0) {
+		pr_debug("Excess octets in signature subpacket stream\n");
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+struct pgp_parse_sig_params_ctx {
+	struct pgp_parse_sig_context base;
+	struct pgp_sig_parameters *params;
+	bool got_the_issuer;
+};
+
+/*
+ * Process a V4 signature subpacket.
+ */
+static int pgp_process_sig_params_subpkt(struct pgp_parse_sig_context *context,
+					 enum pgp_sig_subpkt_type type,
+					 const u8 *data,
+					 size_t datalen)
+{
+	struct pgp_parse_sig_params_ctx *ctx =
+		container_of(context, struct pgp_parse_sig_params_ctx, base);
+
+	if (ctx->got_the_issuer) {
+		pr_debug("V4 signature packet has multiple issuers\n");
+		return -EBADMSG;
+	}
+
+	if (datalen != 8) {
+		pr_debug("V4 signature issuer subpkt not 8 long (%zu)\n",
+			   datalen);
+		return -EBADMSG;
+	}
+
+	memcpy(&ctx->params->issuer, data, 8);
+	ctx->got_the_issuer = true;
+	return 0;
+}
+
+/**
+ * pgp_parse_sig_params - Parse basic parameters from a PGP signature packet
+ * @_data: Content of packet (updated)
+ * @_datalen: Length of packet remaining (updated)
+ * @p: The basic parameters
+ *
+ * Parse the basic parameters from a PGP signature packet [RFC 4880: 5.2] that
+ * are needed to start off a signature verification operation.  The only ones
+ * actually necessary are the signature type (which affects how the data is
+ * transformed) and the hash algorithm.
+ *
+ * We also extract the public key algorithm and the issuer's key ID as we'll
+ * need those to determine if we actually have the public key available.  If
+ * not, then we can't verify the signature anyway.
+ *
+ * Returns 0 if successful or a negative error code.  *_data and *_datalen are
+ * updated to point to the 16-bit subset of the hash value and the set of MPIs.
+ */
+int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
+			 struct pgp_sig_parameters *p)
+{
+	const u8 *data = *_data;
+	size_t datalen = *_datalen;
+	int ret;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 1)
+		return -EBADMSG;
+	p->version = *data;
+
+	if (p->version == PGP_SIG_VERSION_3) {
+		const struct pgp_signature_v3_packet *v3 = (const void *)data;
+
+		if (datalen < sizeof(*v3)) {
+			pr_debug("Short V3 signature packet\n");
+			return -EBADMSG;
+		}
+		datalen -= sizeof(*v3);
+		data += sizeof(*v3);
+
+		/* V3 has everything we need in the header */
+		p->signature_type = v3->hashed.signature_type;
+		memcpy(&p->issuer, &v3->issuer, 8);
+		p->pubkey_algo = v3->pubkey_algo;
+		p->hash_algo = v3->hash_algo;
+
+	} else if (p->version == PGP_SIG_VERSION_4) {
+		const struct pgp_signature_v4_packet *v4 = (const void *)data;
+		struct pgp_parse_sig_params_ctx ctx = {
+			.base.process_packet = pgp_process_sig_params_subpkt,
+			.params = p,
+			.got_the_issuer = false,
+		};
+		size_t subdatalen;
+
+		if (datalen < sizeof(*v4) + 2 + 2 + 2) {
+			pr_debug("Short V4 signature packet\n");
+			return -EBADMSG;
+		}
+		datalen -= sizeof(*v4);
+		data += sizeof(*v4);
+
+		/* V4 has most things in the header... */
+		p->signature_type = v4->signature_type;
+		p->pubkey_algo = v4->pubkey_algo;
+		p->hash_algo = v4->hash_algo;
+
+		/* ... but we have to get the key ID from the subpackets, of
+		 * which there are two sets.
+		 */
+		__set_bit(PGP_SIG_ISSUER, ctx.base.types_of_interest);
+
+		subdatalen  = *data++ << 8;
+		subdatalen |= *data++;
+		datalen -= 2;
+		if (subdatalen) {
+			/* Hashed subpackets */
+			pr_devel("hashed data: %zu (after %zu)\n",
+				 subdatalen, sizeof(*v4));
+			if (subdatalen > datalen + 2 + 2) {
+				pr_debug("Short V4 signature packet [hdata]\n");
+				return -EBADMSG;
+			}
+			ret = pgp_parse_sig_subpkts(data, subdatalen,
+						    &ctx.base);
+			if (ret < 0)
+				return ret;
+			data += subdatalen;
+			datalen -= subdatalen;
+		}
+
+		subdatalen  = *data++ << 8;
+		subdatalen |= *data++;
+		datalen -= 2;
+		if (subdatalen) {
+			/* Unhashed subpackets */
+			pr_devel("unhashed data: %zu\n", subdatalen);
+			if (subdatalen > datalen + 2) {
+				pr_debug("Short V4 signature packet [udata]\n");
+				return -EBADMSG;
+			}
+			ret = pgp_parse_sig_subpkts(data, subdatalen,
+						    &ctx.base);
+			if (ret < 0)
+				return ret;
+			data += subdatalen;
+			datalen -= subdatalen;
+		}
+
+		if (!ctx.got_the_issuer) {
+			pr_debug("V4 signature packet lacks issuer\n");
+			return -EBADMSG;
+		}
+	} else {
+		pr_debug("Signature packet with unhandled version %d\n",
+			 p->version);
+		return -EBADMSG;
+	}
+
+	*_data = data;
+	*_datalen = datalen;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_sig_params);
diff --git a/include/linux/pgplib.h b/include/linux/pgplib.h
index 7db21b69a6fe..44c8a07b32e3 100644
--- a/include/linux/pgplib.h
+++ b/include/linux/pgplib.h
@@ -41,6 +41,31 @@ struct pgp_parse_pubkey {
 extern int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
 				struct pgp_parse_pubkey *pk);
 
+struct pgp_parse_sig_context {
+	unsigned long types_of_interest[128 / BITS_PER_LONG];
+	int (*process_packet)(struct pgp_parse_sig_context *context,
+			      enum pgp_sig_subpkt_type type,
+			      const u8 *data,
+			      size_t datalen);
+};
+
+extern int pgp_parse_sig_packets(const u8 *data, size_t datalen,
+				 struct pgp_parse_sig_context *ctx);
+
+struct pgp_sig_parameters {
+	enum pgp_signature_version version : 8;
+	enum pgp_signature_type signature_type : 8;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	enum pgp_hash_algo hash_algo : 8;
+	union {
+		struct pgp_key_ID issuer;
+		__be32 issuer32[2];
+	};
+};
+
+extern int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
+				struct pgp_sig_parameters *p);
+
 
 #endif /* CONFIG_PGP_LIBRARY */
 
-- 
2.17.1
