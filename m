Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3D4C04A95
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 20:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiIWURa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiIWUP3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 16:15:29 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD41135711
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id y5so1595879wrh.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LqvkFCVCjfa7ILnjOvpfFzjAz1hFv+OuedSgBSKgSnc=;
        b=dASSeeXmaKEDFIEpWQgMRlQAuiOWIUSOdmJjKkGDgoXy9J72ds0K0tj0DjLpitLAfb
         pyHEkrfVsIUPlTrJPZQQrU3X9umCQ792x+u5AbB122ybV+ilTXp6bq/nBS4pA0hfSig0
         mu2fuMKTAbtsNpktGbK/6jCSk9WkPaYwOENc3cKWa6XnVaoRj+7pVX9oHV2BLGiblrLO
         hvJKAJEtHqZfbzVUsh6cIP1J9GDYgZu5OT1eLeLxVSDvz2guAINOaEYT3QBRv6cUrAMc
         nF3GiqN1pkXy/k5ddngK74F67NKvHx+p+Pobe6oS5St4ZewXcQdZfr3KZUFQ8IXvKHVp
         CQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LqvkFCVCjfa7ILnjOvpfFzjAz1hFv+OuedSgBSKgSnc=;
        b=tD5cQMdGm5Sz/Dyk9grbDuMz5lHiEIbRSwsS9LldsHpkFg2X9GiAg7g11hnA+TkfdZ
         XWbRxZ/W/4+YWdk/wnLFqCgra+T4gLkDCAmS6NbaRnEJvKMO5CjzaCEcTQ7QnB5v8lvg
         J8/fKR+q0xpr8rEBE9oC6gZnV7mWaSg/KY38lbR/1iaq8Suhs3DjchVD67OqZYrCJd/b
         legjVKQ+wOnnqd5Fh7huJAGgTp/RpwzYBXXOXlfkvEDg6avWoey271BnulShf2xqZbcn
         emt+EEiDVxrR/xvvioeqV5+MfZhQb3LLojRGkQG6u/In/ng+7XWIynZ/nFb6N+IqBpbu
         200g==
X-Gm-Message-State: ACrzQf2U7Gavh+HzooQRKx39nm1WibH7Yg1lfP1sQYOVfH9gKJ8MoylY
        dZsOhm1CVE03rtzlzNDfmwovpQ==
X-Google-Smtp-Source: AMsMyM5qnhpllhRG2HKj/CG2nloo2ZUCnGNX01syZ4Z9PMofeVZUxk7mfTuQotLNdmwmS810AYgEjA==
X-Received: by 2002:a5d:69ca:0:b0:228:dd17:9534 with SMTP id s10-20020a5d69ca000000b00228dd179534mr6602076wrw.652.1663964058126;
        Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:17 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 33/35] selftest/nettest: Rename md5_prefix* => auth_prefix*
Date:   Fri, 23 Sep 2022 21:13:17 +0100
Message-Id: <20220923201319.493208-34-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now it's going to be used for TCP-AO testing too.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/nettest.c | 28 +++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 35831bc3da24..3a887ef783cd 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -97,11 +97,11 @@ struct sock_args {
 
 	const char *password;
 	/* prefix for MD5 password */
-	const char *md5_prefix_str;
+	const char *auth_prefix_str;
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
-	} md5_prefix;
+	} auth_prefix;
 	unsigned int prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
@@ -271,7 +271,7 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_PREFIX;
 
 		md5sig.tcpm_prefixlen = args->prefix_len;
-		addr = &args->md5_prefix;
+		addr = &args->auth_prefix;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
@@ -311,13 +311,13 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
-		sin.sin_addr = args->md5_prefix.v4.sin_addr;
+		sin.sin_addr = args->auth_prefix.v4.sin_addr;
 		addr = &sin;
 		alen = sizeof(sin);
 		break;
 	case AF_INET6:
 		sin6.sin6_port = htons(args->port);
-		sin6.sin6_addr = args->md5_prefix.v6.sin6_addr;
+		sin6.sin6_addr = args->auth_prefix.v6.sin6_addr;
 		addr = &sin6;
 		alen = sizeof(sin6);
 		break;
@@ -750,11 +750,11 @@ static int convert_addr(struct sock_args *args, const char *_str,
 	case ADDR_TYPE_MD5_PREFIX:
 		desc = "md5 prefix";
 		if (family == AF_INET) {
-			args->md5_prefix.v4.sin_family = AF_INET;
-			addr = &args->md5_prefix.v4.sin_addr;
+			args->auth_prefix.v4.sin_family = AF_INET;
+			addr = &args->auth_prefix.v4.sin_addr;
 		} else if (family == AF_INET6) {
-			args->md5_prefix.v6.sin6_family = AF_INET6;
-			addr = &args->md5_prefix.v6.sin6_addr;
+			args->auth_prefix.v6.sin6_family = AF_INET6;
+			addr = &args->auth_prefix.v6.sin6_addr;
 		} else
 			return 1;
 
@@ -837,8 +837,8 @@ static int validate_addresses(struct sock_args *args)
 	    convert_addr(args, args->remote_addr_str, ADDR_TYPE_REMOTE) < 0)
 		return 1;
 
-	if (args->md5_prefix_str &&
-	    convert_addr(args, args->md5_prefix_str,
+	if (args->auth_prefix_str &&
+	    convert_addr(args, args->auth_prefix_str,
 			 ADDR_TYPE_MD5_PREFIX) < 0)
 		return 1;
 
@@ -2020,7 +2020,7 @@ int main(int argc, char *argv[])
 			args.password = optarg;
 			break;
 		case 'm':
-			args.md5_prefix_str = optarg;
+			args.auth_prefix_str = optarg;
 			break;
 		case 'S':
 			args.use_setsockopt = 1;
@@ -2079,13 +2079,13 @@ int main(int argc, char *argv[])
 	}
 
 	if (args.password && (!args.use_md5 ||
-	      (!args.has_remote_ip && !args.md5_prefix_str) ||
+	      (!args.has_remote_ip && !args.auth_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if ((args.md5_prefix_str || args.use_md5) && !args.password) {
+	if ((args.auth_prefix_str || args.use_md5) && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
-- 
2.37.2

