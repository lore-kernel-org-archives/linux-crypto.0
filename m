Return-Path: <SRS0=r6//=6D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A9EC38A30
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 11:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A820214D8
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 11:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgDSLrP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Apr 2020 07:47:15 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:37892 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgDSLrP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Apr 2020 07:47:15 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 8CEFC837F24A;
        Sun, 19 Apr 2020 11:47:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: grade37_79489634b3117
X-Filterd-Recvd-Size: 3450
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sun, 19 Apr 2020 11:47:13 +0000 (UTC)
Message-ID: <e4a2c1206cc8009f0e0881e2b9ec2e828c5d9e7c.camel@perches.com>
Subject: Re: [PATCH] crypto: Delete redundant variable definition
From:   Joe Perches <joe@perches.com>
To:     Tang Bin <tangbin@cmss.chinamobile.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Date:   Sun, 19 Apr 2020 04:44:58 -0700
In-Reply-To: <20200419071245.3924-1-tangbin@cmss.chinamobile.com>
References: <20200419071245.3924-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 2020-04-19 at 15:12 +0800, Tang Bin wrote:
> The variable "i" is redundant to be assigned a value
> of zero,because it's assigned in the for loop, so remove
> redundant one here.
> 
> Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> 
> ---
>  drivers/crypto/bcm/cipher.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index c8b940854..5db23c18c 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -4724,7 +4724,6 @@ static int spu_dt_read(struct platform_device *pdev)
>  	spu->spu_type = matched_spu_type->type;
>  	spu->spu_subtype = matched_spu_type->subtype;
>  
> -	i = 0;
>  	for (i = 0; (i < MAX_SPUS) && ((spu_ctrl_regs =
>  		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL); i++) {

Maybe the for loop could be simplified too by
moving the assignment inside the loop.

Also, the %pe extension could be used.

Perhaps:
---
 drivers/crypto/bcm/cipher.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index c8b940..7d6afa4 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4707,7 +4707,6 @@ static int spu_dt_read(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct spu_hw *spu = &iproc_priv.spu;
-	struct resource *spu_ctrl_regs;
 	const struct spu_type_subtype *matched_spu_type;
 	struct device_node *dn = pdev->dev.of_node;
 	int err, i;
@@ -4724,19 +4723,23 @@ static int spu_dt_read(struct platform_device *pdev)
 	spu->spu_type = matched_spu_type->type;
 	spu->spu_subtype = matched_spu_type->subtype;
 
-	i = 0;
-	for (i = 0; (i < MAX_SPUS) && ((spu_ctrl_regs =
-		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL); i++) {
+	for (i = 0; i < MAX_SPUS; i++) {
+		struct resource *spu_ctrl_regs;
+
+		spu_ctrl_regs = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!spu_ctrl_regs)
+			break;
 
 		spu->reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
 		if (IS_ERR(spu->reg_vbase[i])) {
 			err = PTR_ERR(spu->reg_vbase[i]);
-			dev_err(&pdev->dev, "Failed to map registers: %d\n",
-				err);
+			dev_err(&pdev->dev, "Failed to map registers: %pe\n",
+				spu->reg_vbase[i]);
 			spu->reg_vbase[i] = NULL;
 			return err;
 		}
 	}
+
 	spu->num_spu = i;
 	dev_dbg(dev, "Device has %d SPUs", spu->num_spu);
 

