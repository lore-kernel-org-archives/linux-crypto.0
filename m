Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917F3C4363C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 16:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342E220758
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 16:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EUWoZFfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbgJBQb5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387768AbgJBQb5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 12:31:57 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCCDC0613D0;
        Fri,  2 Oct 2020 09:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Tp32auPjFMJgqgloLtElKDiNxQUVq6xL7O99uFLsZo0=; b=EUWoZFfFwsgn352Atn09jfhmd8
        YwZtotGm8CrN424c08LVYRTpobhmsuMfSiiisb0BRKnvDWoY/fH1h7JI7Kzovy0EjHdbOoq6uJ9Xu
        eZkqoG7Kenul+1LPHyRlg5mYjjvWIt6sl4cG91sAYYaKLuyMoklV65zWGBTJ6wR3N/EnPay3hk+ZW
        rVpUA4kQQFn+HSRFr3U+4T7vcJ2BRe2/ZBCVi+X6x6NEbBiWgibRMATrTODR7c2fGjYNYxulEngjE
        y0+S2U3h6xuiw4x0LzCYZ/Zg0NXNMrBghiMNwsZkVhjXD4K2BHiUZ0mfAExTDqlawSvspThfRlskP
        JlekhUCg==;
Received: from [2601:1c0:6280:3f0::2c9a]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kONxR-0005Fk-2F; Fri, 02 Oct 2020 16:30:57 +0000
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002140428.GC3475053@kroah.com>
 <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002151300.GC5212@kroah.com>
 <CY4PR0401MB3652EA0FFA3CD9679172B02CC3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <59b7bd3d-e78b-0d74-8a30-a3a6621b380e@infradead.org>
Date:   Fri, 2 Oct 2020 09:30:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CY4PR0401MB3652EA0FFA3CD9679172B02CC3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/2/20 8:39 AM, Van Leeuwen, Pascal wrote:
>> -----Original Message-----
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Sent: Friday, October 2, 2020 5:13 PM
>> To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>
>> Cc: Torsten Duwe <duwe@lst.de>; Theodore Y. Ts'o <tytso@mit.edu>; linux-crypto@vger.kernel.org; Nicolai Stange
>> <nstange@suse.de>; LKML <linux-kernel@vger.kernel.org>; Arnd Bergmann <arnd@arndb.de>; Eric W. Biederman
>> <ebiederm@xmission.com>; Alexander E. Patrakov <patrakov@gmail.com>; Ahmed S. Darwish <darwish.07@gmail.com>; Willy
>> Tarreau <w@1wt.eu>; Matthew Garrett <mjg59@srcf.ucam.org>; Vito Caputo <vcaputo@pengaru.com>; Andreas Dilger
>> <adilger.kernel@dilger.ca>; Jan Kara <jack@suse.cz>; Ray Strode <rstrode@redhat.com>; William Jon McCann <mccann@jhu.edu>;
>> zhangjs <zachary@baishancloud.com>; Andy Lutomirski <luto@kernel.org>; Florian Weimer <fweimer@redhat.com>; Lennart
>> Poettering <mzxreary@0pointer.de>; Peter Matthias <matthias.peter@bsi.bund.de>; Marcelo Henrique Cerri
>> <marcelo.cerri@canonical.com>; Neil Horman <nhorman@redhat.com>; Randy Dunlap <rdunlap@infradead.org>; Julia Lawall
>> <julia.lawall@inria.fr>; Dan Carpenter <dan.carpenter@oracle.com>; Andy Lavr <andy.lavr@gmail.com>; Eric Biggers
>> <ebiggers@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Stephan Müller <smueller@chronox.de>; Petr Tesarik
>> <ptesarik@suse.cz>
>> Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
>>
>> <<< External Email >>>
>> On Fri, Oct 02, 2020 at 02:34:44PM +0000, Van Leeuwen, Pascal wrote:
>>>
>>>
>>>
>>>> -----Original Message-----
>>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Sent: Friday, October 2, 2020 4:04 PM
>>>> To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>
>>>> Cc: Torsten Duwe <duwe@lst.de>; Theodore Y. Ts'o <tytso@mit.edu>; linux-crypto@vger.kernel.org; Nicolai Stange
>>>> <nstange@suse.de>; LKML <linux-kernel@vger.kernel.org>; Arnd Bergmann <arnd@arndb.de>; Eric W. Biederman
>>>> <ebiederm@xmission.com>; Alexander E. Patrakov <patrakov@gmail.com>; Ahmed S. Darwish <darwish.07@gmail.com>; Willy
>>>> Tarreau <w@1wt.eu>; Matthew Garrett <mjg59@srcf.ucam.org>; Vito Caputo <vcaputo@pengaru.com>; Andreas Dilger
>>>> <adilger.kernel@dilger.ca>; Jan Kara <jack@suse.cz>; Ray Strode <rstrode@redhat.com>; William Jon McCann
>> <mccann@jhu.edu>;
>>>> zhangjs <zachary@baishancloud.com>; Andy Lutomirski <luto@kernel.org>; Florian Weimer <fweimer@redhat.com>; Lennart
>>>> Poettering <mzxreary@0pointer.de>; Peter Matthias <matthias.peter@bsi.bund.de>; Marcelo Henrique Cerri
>>>> <marcelo.cerri@canonical.com>; Neil Horman <nhorman@redhat.com>; Randy Dunlap <rdunlap@infradead.org>; Julia Lawall
>>>> <julia.lawall@inria.fr>; Dan Carpenter <dan.carpenter@oracle.com>; Andy Lavr <andy.lavr@gmail.com>; Eric Biggers
>>>> <ebiggers@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Stephan Müller <smueller@chronox.de>; Petr Tesarik
>>>> <ptesarik@suse.cz>
>>>> Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
>>>>
>>>> <<< External Email >>>
>>>> On Fri, Oct 02, 2020 at 01:35:18PM +0000, Van Leeuwen, Pascal wrote:
>>>>> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is
>>>> confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying,
>>>> forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
>>>>
>>>> As per my legal department requests, this is now ignored and deleted on
>>>> my system...
>>>>
>>>> Hint, it's not a valid footer for public mailing lists...
>>>>
>>>> greg k-h
>>> It's automatically added by our company mail server ... not something I can control at all :-(
>>
>> Then your company can not contribute in Linux kernel development, as
>> this is obviously not allowed by such a footer.
>>
> Interesting, this has never been raised as a problem until today ...
> Going back through my mail archive, it looks like they started automatically adding that some
> 3 months ago. Not that they informed anyone about that, it just silently happened.
> 
>> Please work with your IT and legal department to fix this.
>>
> Eh ... Greg ... that's not how that works in the real world. In the real world, legal and IT lay
> down the law and you just comply with that (or hack your way around it, if you can ;-).

That's how it worked at $big_companies that I have worked at.

If it's a company/business requirement that you do Linux kernel development work, (is it?)
then they should make that possible on internal systems or give you access to
external email server(s).

> I'm already fighting the good fight trying to keep control of my development machines
> because IT would just love to get rid of those (since not under IT control .... oh dear ...)
> And obviously, you cannot do kernel development on a machine without root access.
> It's annoying enough already to require IT support to provide explicit permission to open
> the task manager on my own company laptop ... grmbl.
> 
>>
>> thanks,
>>
>> greg k-h
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
> 
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail address.
> 
> 
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
> 
> Rambus Inc.<http://www.rambus.com>
> 


-- 
~Randy

