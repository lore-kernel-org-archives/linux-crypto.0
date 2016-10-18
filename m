From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH -next] crypto: ccp - Fix non static symbol warning
Date: Tue, 18 Oct 2016 13:04:32 -0500
Message-ID: <c6eb6092-c1a7-29af-82cd-c38db7350615@amd.com>
References: <1476716930-9831-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:9568
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030378AbcJRSU1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 14:20:27 -0400
In-Reply-To: <1476716930-9831-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/17/2016 10:08 AM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Fixes the following sparse warning:
>
> drivers/crypto/ccp/ccp-dev.c:44:6: warning:
>  symbol 'ccp_error_codes' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Excellent. Thank you.

Acked-by: Gary R Hook <gary.hook@amd.com>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
