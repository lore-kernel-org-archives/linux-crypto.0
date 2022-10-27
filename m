Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20059ECAAA1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Oct 2022 20:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiJ0Uur (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237154AbiJ0Usq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2022 16:48:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB61167E6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 13:44:48 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w14so4155815wru.8
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 13:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MoGdmlHHpEUPuXthWjW8u1iP64OMQnsBPTKyfVuhzXI=;
        b=gSAoOgAv2U5kJtyYr7yDdRnMNeIyd8FzGikQ98Di2J6T1ItIL6ZS7GHQKzHKdPPYKd
         +8ruIARt0FKlU/ZUA3yWYh5WA5tb5Ewekp8C6bFUOTRHypdAcBI4RNf5z1duywraGfQc
         +znM2TcBP5AMUY+8iu94mJECQWwO7BeRw20D3ywcHjHkECx3pz9e7GMpwln4EgzTlSPu
         X4m6PFwa7d/J+znya2T3k/IxWaPAeZ8v9NfmbuBL04iSsWxQsFzNeEDveG4N1YBubKte
         IP0+9DtaAt6hKJxAyxfOrKY4qVMoYPwfqA+s8SDg/kH6chE6FYJaj0WP9Jzn3aJGFl+2
         F7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MoGdmlHHpEUPuXthWjW8u1iP64OMQnsBPTKyfVuhzXI=;
        b=d32SE9ofZmCrFjoDTj4pxhzF/B5UtcLQELOLVCvhMMkw68oCkqsGM1kaqK/iLl/wq0
         Ta9z63n8HknULTDuUJ6PnXyKia8qKgQHuhW/TJzPwflwbbq45y5d0+XOAyiZr/OArxZp
         nJYZpnowmWohVOWrWoAeO14xFsNBXj+AqloeTXTrDZgPGwnH9ju4UbFMCcpNp9RiXyAX
         kCMwWz0H5ViMxIqboVx869c3knjdQRv+0bRgvvE70FqvZ7fFMvqh2iENY/iQZyQyrBlh
         njHV44ANVdVuRkF3Ah7XPWUHT3g5kchZYo8qoOHHydEa6Ns8idh9+vYYCPwEC6EpKQ/d
         CxQA==
X-Gm-Message-State: ACrzQf1ZqCKoUylPAy8m69pNFvJdVGZnvVgERY68RQtrkJv9clXBKNub
        AgvGsQ4Kyb6G2Slxkk/PLp0VlQ==
X-Google-Smtp-Source: AMsMyM51y4XSGK/cdyuNHhoEc2nyqHNHVj8t5fp9PknmjCaJ0QeKC/pAd/WipxL7dQK12trDfHqLqg==
X-Received: by 2002:adf:e64e:0:b0:236:76a9:446 with SMTP id b14-20020adfe64e000000b0023676a90446mr14065104wrn.696.1666903468407;
        Thu, 27 Oct 2022 13:44:28 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:27 -0700 (PDT)
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
Subject: [PATCH v3 22/36] net/tcp: Add option for TCP-AO to (not) hash header
Date:   Thu, 27 Oct 2022 21:43:33 +0100
Message-Id: <20221027204347.529913-23-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide setsockopt() key flag that makes TCP-AO exclude hashing TCP
header for peers that match the key. This is needed for interraction
with middleboxes that may change TCP options, see RFC5925 (9.2).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/uapi/linux/tcp.h | 2 ++
 net/ipv4/tcp_ao.c        | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 508bedbc6ad8..b60933ee2a27 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -347,6 +347,8 @@ struct tcp_diag_md5sig {
 
 #define TCP_AO_MAXKEYLEN	80
 
+#define TCP_AO_KEYF_EXCLUDE_OPT	(1 << 0)
+
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index e5b4e9f1e83e..90b864d4ee7d 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -604,7 +604,8 @@ int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
 		WARN_ON_ONCE(1);
 		goto clear_hash;
 	}
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
@@ -646,7 +647,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		goto clear_hash;
 	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
 		goto clear_hash;
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	if (tcp_ao_hash_skb_data(&hp, skb, th->doff << 2))
@@ -1497,7 +1499,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 }
 #endif
 
-#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-- 
2.38.1

