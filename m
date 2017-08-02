From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [Patch V3] crypto: x86/sha1 : Fix reads beyond the number of
 blocks passed
Date: Wed, 2 Aug 2017 15:18:50 -0400 (EDT)
Message-ID: <964539021.65400093.1501701530053.JavaMail.zimbra@redhat.com>
References: <1501694015-10203-1-git-send-email-megha.dey@linux.intel.com> <1501698918.9349.1.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
        tim c chen <tim.c.chen@linux.intel.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ilya albrekht <ilya.albrekht@intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751956AbdHBTSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 15:18:52 -0400
In-Reply-To: <1501698918.9349.1.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>




----- Original Message -----
> On Wed, 2017-08-02 at 10:13 -0700, Megha Dey wrote:
> > It was reported that the sha1 AVX2 function(sha1_transform_avx2) is
> > reading ahead beyond its intended data, and causing a crash if the next
> > block is beyond page boundary:
> > http://marc.info/?l=linux-crypto-vger&m=149373371023377
> > 
> > This patch makes sure that there is no overflow for any buffer length.
> > 
> > It passes the tests written by Jan Stancek that revealed this problem:
> > https://github.com/jstancek/sha1-avx2-crash
> 
> Hi Jan,
> 
> Is it ok to add your Tested-by?

Yes, v3 patch is exactly the diff I was testing.

Regards,
Jan
