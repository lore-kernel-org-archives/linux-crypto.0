Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3525C32774
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 17:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345263AbiHRRDI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345218AbiHRRAz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 13:00:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630FACAC4D
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 10:00:46 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so2454507wri.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=E96d+BUrTn5halPp8rfKr4BR8z1gBILVpe/NiX4cSOM=;
        b=eslQLaOzrcgU+TRthmIrk4mKFUgv2ctqWMVMZzQP0h0E239TBd1c7aKhEo7C/YzZ/C
         n7qHTZ6qwnHwfEsyv3qjq4zdUnTSfph5M85c2pNWOQGAOexNTh9GYAIZFMPu/I222L9d
         Mj+MEHoAnDCvD4C5aeMu+PBR7/Ka8JntqGQ9nNqXI9KTFsSJg2M5EbK+I6qTeVcf4hVE
         TaNmgPLUqAEB4woL44kBOYSY5eqB8JRJnDJo4o7VirvB2PPy5MnHrZwXoWOckXR/DmEF
         wv9LZpATOuEKyUYgXls4Qc48x1Cx/RXWfTZuJcv6SH1tOUV+reeKOAAqF7hL9Hcs4D04
         kEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=E96d+BUrTn5halPp8rfKr4BR8z1gBILVpe/NiX4cSOM=;
        b=Euaqy4jdXF2X+0lYFCve0UUji/Tlt8ALUGjzYZU/6ul8w7ippVvDDgSMmUKRQkVrlq
         YRLRrBTNFfwYjDxYCE7qp4iEoH8OZVtuxZ88cZ0qkkpfDTR232JPkuFwO8DJ9Blu9txo
         CA8z7PbnQx7dhZQMuU6pWqc0E/RFoDzBUd8PMx37+4nIOHqw5XnduEHmnxlZ4zT8ZA+v
         Svk5FLf0egCVIQNDAMIuutVat9ACtlVk4qjLRa9UV7PY5YKzSt6r7LrzpaclTE/VJ+2/
         5jczUB7OLbWwcQKyjaEIZSlQH2pjPciR4sSVVd54w4j7RWq9BJJGpoLQoWqDKB2EOffk
         7h4A==
X-Gm-Message-State: ACgBeo10Noa0aqlZLtrNl4TQy8qO95vc1iqDPVgpU9yhSMafQeTjblVN
        NNiXMvauKjcWUvWzIsxtWArIPw==
X-Google-Smtp-Source: AA6agR4jWu5q16URuIM703Kk3SvvJ3fM5QAgSFFuhVHEhWOkBCOL26w1vKN1rgalbG1P0R6Kg4uQJw==
X-Received: by 2002:adf:e10c:0:b0:225:3168:c261 with SMTP id t12-20020adfe10c000000b002253168c261mr1433771wrz.159.1660842045923;
        Thu, 18 Aug 2022 10:00:45 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:45 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 22/31] net/tcp: Add option for TCP-AO to (not) hash header
Date:   Thu, 18 Aug 2022 17:59:56 +0100
Message-Id: <20220818170005.747015-23-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
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
index 858295393643..6e18a8cdee90 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -586,7 +586,8 @@ int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
 						&saddr->a6, th->doff * 4))
 			goto clear_hash;
 	}
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
@@ -628,7 +629,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		goto clear_hash;
 	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
 		goto clear_hash;
-	if (tcp_ao_hash_header(&hp, th, false,
+	if (tcp_ao_hash_header(&hp, th,
+			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
 			       ao_hash, hash_offset, tcp_ao_maclen(key)))
 		goto clear_hash;
 	if (tcp_ao_hash_skb_data(&hp, skb, th->doff << 2))
@@ -1416,7 +1418,7 @@ static bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 	return false;
 }
 
-#define TCP_AO_KEYF_ALL		(0)
+#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-- 
2.37.2

