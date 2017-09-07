From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3] Staging: ccree: ssi_cipher.c: Remove unused variable.
Date: Wed, 06 Sep 2017 23:16:52 -0700
Message-ID: <1504765012.7546.12.camel@perches.com>
References: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
         <20170906213243.gyttos3s64ckoswp@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:41436 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751369AbdIGGQ4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 02:16:56 -0400
In-Reply-To: <20170906213243.gyttos3s64ckoswp@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2017-09-07 at 00:32 +0300, Dan Carpenter wrote:
> Always compile your patches.
> 
>   CC [M]  drivers/staging/ccree/ssi_cipher.o
> drivers/staging/ccree/ssi_cipher.c: In function ‘ssi_blkcipher_complete’:
> drivers/staging/ccree/ssi_cipher.c:700:6: warning: unused variable ‘inflight_counter’ [-Wunused-variable]
>   u32 inflight_counter;
>       ^~~~~~~~~~~~~~~~
> 
> You need to delete the declaration as well.
> 
> Don't be in a rush to resend patches.  I normally write them then let
> them sit in my outbox overnight and send them in the morning.  The extra
> delay helps me to calm down a bit and focus better.  Even though I've
> sent thousands of patches, it sometimes still stresses me out.  It's
> like you're disagreeing with the original author and the reviewers are
> disagreeing with you and everyone's trying to be nice about it but
> patches are fundamentally points of disagreement and that's stress.

True, and you shouldn't add a blank link either.
there's already one above the block you deleted.
