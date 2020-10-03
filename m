Return-Path: <SRS0=yz7Y=DK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6E4C41604
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 17:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D2820691
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 17:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgJCRNp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Oct 2020 13:13:45 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:15704 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgJCRNp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Oct 2020 13:13:45 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4C3YNg1NrZz9vBn3;
        Sat,  3 Oct 2020 19:13:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id tvbExPn2qxUn; Sat,  3 Oct 2020 19:13:39 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4C3YNg0bfpz9vBn1;
        Sat,  3 Oct 2020 19:13:39 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 4940BC4E; Sat,  3 Oct 2020 19:15:53 +0200 (CEST)
Received: from 192.168.4.90 ([192.168.4.90]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sat, 03 Oct 2020 19:15:53 +0200
Date:   Sat, 03 Oct 2020 19:15:53 +0200
Message-ID: <20201003191553.Horde.qhVjpQA-iJND7COibFfWZQ7@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?b?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Kim Phillips <kim.phillips@arm.com>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] crypto: talitos - Fix sparse warnings
References: <20201002115236.GA14707@gondor.apana.org.au>
 <be222fed-425b-d55c-3efc-9c4e873ccf8e@csgroup.eu>
 <20201002124223.GA1547@gondor.apana.org.au>
 <20201002124341.GA1587@gondor.apana.org.au>
In-Reply-To: <20201002124341.GA1587@gondor.apana.org.au>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Fri, Oct 02, 2020 at 10:42:23PM +1000, Herbert Xu wrote:
>>
>> I don't think that's a valid optimisation unless it's backed up
>> with real numbers.
>
> Also it only matters on little-endian as they're no-ops on big-endian.
> If I'm right then this driver never even worked on little-endian.
>

The following changes fix the sparse warnings with less churn:

---
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7c547352a862..992d58a4dbf1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -460,7 +460,7 @@ DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
  /*
   * locate current (offending) descriptor
   */
-static u32 current_desc_hdr(struct device *dev, int ch)
+static __be32 current_desc_hdr(struct device *dev, int ch)
  {
  	struct talitos_private *priv = dev_get_drvdata(dev);
  	int tail, iter;
@@ -478,7 +478,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)

  	iter = tail;
  	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
-	       priv->chan[ch].fifo[iter].desc->next_desc != cur_desc) {
+	       priv->chan[ch].fifo[iter].desc->next_desc != cpu_to_be32(cur_desc)) {
  		iter = (iter + 1) & (priv->fifo_len - 1);
  		if (iter == tail) {
  			dev_err(dev, "couldn't locate current descriptor\n");
@@ -486,7 +486,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)
  		}
  	}

-	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc) {
+	if (priv->chan[ch].fifo[iter].desc->next_desc == cpu_to_be32(cur_desc)) {
  		struct talitos_edesc *edesc;

  		edesc = container_of(priv->chan[ch].fifo[iter].desc,
@@ -501,13 +501,13 @@ static u32 current_desc_hdr(struct device *dev, int ch)
  /*
   * user diagnostics; report root cause of error based on execution  
unit status
   */
-static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
+static void report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
  {
  	struct talitos_private *priv = dev_get_drvdata(dev);
  	int i;

  	if (!desc_hdr)
-		desc_hdr = in_be32(priv->chan[ch].reg + TALITOS_DESCBUF);
+		desc_hdr = cpu_to_be32(in_be32(priv->chan[ch].reg + TALITOS_DESCBUF));

  	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
  	case DESC_HDR_SEL0_AFEU:
---
Christophe
