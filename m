Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F6FC636D3
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 01:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjAaB0s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAaB0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 20:26:48 -0500
Received: from aib29gb125.yyz1.oracleemaildelivery.com (aib29gb125.yyz1.oracleemaildelivery.com [192.29.72.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9CC222FF
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 17:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EFHwUA9Tkpmw6k4GEqDKW3t/SV1Q0J+L8OeigPfj34M=;
 b=SIbvZpQ/f/DEzSH3+kQt0jQnBGiVls7qeaIDaNhP2PJ8zowLdSY9gBdeUmcY8wEyFe0n/9AMM7Dw
   QwVEi3G5obfrjFgiKj/5TlS+PJMNexW9lw2Gr7msnYG0JI2jeOR2TOsMqSDS/cWPPggqBsUqPGk0
   yhvIE06c9uJLQ9nb60l3dTpUV6P1kYHjZhl2cLq817Nglg/kqn2FUTV6VX6NxVirI6t01jY9HM7w
   BcEkm7ca0+MhpUW/c/l5rwtKBgWVQj4CDs10kUeZ0JJjWohkzBUBPJPQQRli7UnMc/Ler+YR16i2
   +CfEhB6r+TnsZUnokZJQUNAFGFtb0OlzhWC9gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EFHwUA9Tkpmw6k4GEqDKW3t/SV1Q0J+L8OeigPfj34M=;
 b=m2029v3U0RxDuYxRThLjTxOvJfYvn/gsYFKmvwZuUDtCbjLMv47qK/DiDLunmiguKs1BsdcgxT9o
   AuCSxdOPPc/QGcQEob0Y9MlcfuN1Akt0/vKvhpWThgNgYmABrB7qRq0fgIUFNNtzJLH8tInAWYUT
   d+OoihMZVQPO5QSgqZZfSlh7Q55UfnpDyhMIuD1BTJK8505Ymr1SvWcCMVmzVRJ/Z/+FbxjfSdZD
   MNfP5z44WcyNelkGMgXshk3BH6abDL6w97yvPfMYKrjXYfTb8sLj7hZutuW9ubt7tt8mJ48V8xmV
   FSFhH7tU4z9XpOJtFAC/6y9d35q5KKuvQV6zSQ==
Received: by omta-ad1-fd2-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPB00744TCLEJ00@omta-ad1-fd2-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Tue, 31 Jan 2023 01:26:45 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH v2 0/3] crypto: x86/blowfish - Cleanup and convert to ECB/CBC
 macros
Date:   Mon, 30 Jan 2023 20:26:23 -0500
Message-id: <20230131012624.6230-1-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAEteT6nhtSJC5yvk27zuBZexFe292wfs99ey1Dc5Q4RVBSj5Oet4txWpCt9HriU
 2JFcH9jpE1cuXPl86VaqnxBv9QdjGpYDFtph1sDJlcvyjlDrb0YEuERApNAoBIlX
 8cLtSla6+Yvz68Np0ttj9cE4z3o1VraUf8aO9361CXnxAtfo37x+kvCZxGTEQ8Wr
 UbFSnoZAd2fmTjw9vgaBAWg4hPpotiMFI6u92DytjqZsySfvbkghbiqnNaqbnJSp
 qiRjcaSwTJWofIakHPlswM3TpqSdhneYCk7IBscB3reC0AtmOQ5x1zKTcX7+G1oj
 8PSK6OBIZegI19yXrkh2c96GvwwRGBNGDjjWwEtZrHunngobteyHbDkcRAuqG7CA
 a7CUk7XwVn5JfUVj/2yvBkUxK5pMycnM0URc1nj8GEu4WUFYab+DK1AqK4MkcVbc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We can acheive a reduction in code size by cleaning up unused logic in
assembly functions, and by replacing handwritten ECB/CBC routines with
helper macros from 'ecb_cbc_helpers.h'.

Additionally, these changes can allow future x86_64 optimized
implementations to take advantage of blowfish-x86_64's fast 1-way and
4-way functions with less code churn.

When testing the patch, I saw a few percent lower cycle counts per
iteration on Intel Skylake for both encryption and decryption. This
is merely a single observation and this series has not been rigorously
benchmarked, as performance changes are not expected. 

v1 -> v2:
 - Fixed typo that caused an assembler failure
 - Added note about performance to cover letter

Peter Lafreniere (3):
  crypto: x86/blowfish - Remove unused encode parameter
  crypto: x86/blowfish - Convert to use ECB/CBC helpers
  crypto: x86/blowfish - Eliminate use of SYM_TYPED_FUNC_START in asm

 arch/x86/crypto/blowfish-x86_64-asm_64.S |  71 ++++----
 arch/x86/crypto/blowfish_glue.c          | 200 +++--------------------
 2 files changed, 55 insertions(+), 216 deletions(-)

-- 
2.39.1

