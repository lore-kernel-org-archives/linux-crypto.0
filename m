From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3] Staging: ccree: ssi_cipher.c: Remove unused variable.
Date: Thu, 7 Sep 2017 00:32:43 +0300
Message-ID: <20170906213243.gyttos3s64ckoswp@mwanda>
References: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Always compile your patches.

  CC [M]  drivers/staging/ccree/ssi_cipher.o
drivers/staging/ccree/ssi_cipher.c: In function ‘ssi_blkcipher_complete’:
drivers/staging/ccree/ssi_cipher.c:700:6: warning: unused variable ‘inflight_counter’ [-Wunused-variable]
  u32 inflight_counter;
      ^~~~~~~~~~~~~~~~

You need to delete the declaration as well.

Don't be in a rush to resend patches.  I normally write them then let
them sit in my outbox overnight and send them in the morning.  The extra
delay helps me to calm down a bit and focus better.  Even though I've
sent thousands of patches, it sometimes still stresses me out.  It's
like you're disagreeing with the original author and the reviewers are
disagreeing with you and everyone's trying to be nice about it but
patches are fundamentally points of disagreement and that's stress.

regards,
dan carpenter
