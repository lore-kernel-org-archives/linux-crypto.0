Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04F0C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 16:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA7A82085A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 16:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfAVQkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:40:32 -0500
Received: from ale.deltatee.com ([207.54.116.67]:51998 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfAVQkb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 11:40:31 -0500
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.89)
        (envelope-from <logang@deltatee.com>)
        id 1glz64-0000xC-4Q; Tue, 22 Jan 2019 09:40:20 -0700
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
References: <20190116182523.19446-1-logang@deltatee.com>
 <20190122124044.GA11753@kroah.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9fe43579-77e2-f845-0b30-4fea4ecc27a7@deltatee.com>
Date:   Tue, 22 Jan 2019 09:40:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122124044.GA11753@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: horia.geanta@nxp.com, andy.shevchenko@gmail.com, arnd@arndb.de, akpm@linux-foundation.org, linux-mm@kvack.org, linux-crypto@vger.kernel.org, linux-ntb@googlegroups.com, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v25 0/6] Add io{read|write}64 to io-64-atomic headers
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019-01-22 5:40 a.m., Greg Kroah-Hartman wrote:
> On Wed, Jan 16, 2019 at 11:25:17AM -0700, Logan Gunthorpe wrote:
>> This is resend number 6 since the last change to this series.
>>
>> This cleanup was requested by Greg KH back in June of 2017. I've resent the series
>> a couple times a cycle since then, updating and fixing as feedback was slowly
>> recieved some patches were alread accepted by specific arches. In June 2018,
>> Andrew picked the remainder of this up and it was in linux-next for a
>> couple weeks. There were a couple problems that were identified and addressed
>> back then and I'd really like to get the ball rolling again. A year
>> and a half of sending this without much feedback is far too long.
>>
>> @Andrew, can you please pick this set up again so it can get into
>> linux-next? Or let me know if there's something else I should be doing.
> 
> version 25?  That's crazy, this has gone on too long.  I've taken this
> into my char/misc driver tree now, so sorry for the long suffering you
> have gone through for this.

Thanks a lot!

Logan
