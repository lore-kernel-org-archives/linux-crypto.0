Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAD_ENC_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03D5C432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 23:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C2920733
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 23:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfKPXhB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 18:37:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34825 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfKPXhB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 18:37:01 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iW7ca-0004q7-ES; Sat, 16 Nov 2019 16:36:52 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iW7cZ-0002Kz-8i; Sat, 16 Nov 2019 16:36:52 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Nicolai Stange <nstange@suse.de>,
        "Peter\, Matthias" <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
        <2787174.DQlWHN5GGo@positron.chronox.de>
        <2476454.l8LQlgn7Hv@positron.chronox.de>
Date:   Sat, 16 Nov 2019 17:36:25 -0600
In-Reply-To: <2476454.l8LQlgn7Hv@positron.chronox.de> ("Stephan
 \=\?utf-8\?Q\?M\=C3\=BCller\=22's\?\=
        message of "Sat, 16 Nov 2019 10:34:12 +0100")
Message-ID: <87k17z4cna.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1iW7cZ-0002Kz-8i;;;mid=<87k17z4cna.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+jtMUClcEVigt0J0xFKcebuOvgMEa2yOk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stephan Müller <smueller@chronox.de> writes:

> The LRNG /proc interface provides the same files as the legacy
> /dev/random. These files behave identically. Yet, all files are
> documented at [1].

For someone who works in this area a lot this description is confusing.

You are talking about sysctls not ordinary proc files.

You don't have a call register_sysctl.  If you want your own
implementation of these sysctls that would seem to be the way to get
them.  Teach each implementation to register their own set of sysctls
if they are enabled.

The entire structure of the code you are adding I have quite confusing,
and a bit messing.

Why add a declaration of random_table in patch 1 and then delete that
declaration in patch 3?  Nothing uses that declaration until this point.

What is the point of adding an extern declaration just before you
declare the table itself?  As I understand the C language that achieves
nothing.  I understand that is what the existing code in
drivers/char/random.c does but that is equally buggy there.

I also don't understand why you don't modify the existing random
generator code into the form you want?  What is the point of a
side-by-side replacement?  Especially since only one of them can
be compiled into the kernel at the same time?

This build a replacement and then switch over seems like a recipe for
loosing the lessons of history because you are not making incremental
changes that can be clearly understood, reviewed and bisected.

As I read your patchset until this change your code will fail to compile
in an ordinary configuration with proc enabled.  Have you even tested
compiling your patchset one patch at a time?

For me a great reorganization to impelment a better structure that fails
to have a good structure on the usual merits makes me dubious about the
entire thing.  As it can be a sign the author was pushing so hard to
make things work he stopped looking at problematic details.

Dubious-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric

> +
> +extern struct ctl_table random_table[];
> +struct ctl_table random_table[] = {
> +	{
