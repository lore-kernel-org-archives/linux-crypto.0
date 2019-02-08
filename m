Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0894CC169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDB2921917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfBHHFF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:05:05 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33966 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfBHHFF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:05:05 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0Db-0000If-UI; Fri, 08 Feb 2019 15:05:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0DY-0008BN-VT; Fri, 08 Feb 2019 15:04:56 +0800
Date:   Fri, 8 Feb 2019 15:04:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: qat - Remove unused goto label
Message-ID: <20190208070456.xywdb3ga2kqwoxaf@gondor.apana.org.au>
References: <20190204110106.345c3e21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204110106.345c3e21@canb.auug.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 04, 2019 at 11:01:06AM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/crypto/qat/qat_common/adf_transport.c: In function 'adf_init_etr_data':
> drivers/crypto/qat/qat_common/adf_transport.c:501:1: warning: label 'err_bank_debug' defined but not used [-Wunused-label]
>  err_bank_debug:
>  ^~~~~~~~~~~~~~
> 
> Introduced by commit
> 
>   f0fcf9ade46a ("crypto: qat - no need to check return value of debugfs_create functions")

Thanks for the report Stephen!

---8<---
This patch removes an unused label.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: f0fcf9ade46a ("crypto: qat - no need to check return...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index ac658ce46836..2136cbe4bf6c 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -498,7 +498,6 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 
 err_bank_all:
 	debugfs_remove(etr_data->debug);
-err_bank_debug:
 	kfree(etr_data->banks);
 err_bank:
 	kfree(etr_data);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
