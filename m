Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16EE9C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 12 May 2022 18:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357657AbiELS3Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 May 2022 14:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245317AbiELS3P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 May 2022 14:29:15 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EDD246D88;
        Thu, 12 May 2022 11:29:14 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:44196)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1npDYm-008rCX-Sm; Thu, 12 May 2022 12:29:12 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37958 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1npDYl-006a2d-Ri; Thu, 12 May 2022 12:29:12 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20220502140602.130373-1-Jason@zx2c4.com>
        <Ym/5EEYHbk56hV1H@zx2c4.com> <Ym/8GTW2RfhnbqiF@gardel-login>
        <YnERsPIsiOCa8cty@zx2c4.com> <Yn1GmlWKIvuoJJby@bombadil.infradead.org>
Date:   Thu, 12 May 2022 13:29:04 -0500
In-Reply-To: <Yn1GmlWKIvuoJJby@bombadil.infradead.org> (Luis Chamberlain's
        message of "Thu, 12 May 2022 10:40:42 -0700")
Message-ID: <87bkw2hafj.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1npDYl-006a2d-Ri;;;mid=<87bkw2hafj.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19z8d4cn9BlzeY/RlkWUjeYBV1bt7jFUbE=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/2] sysctl: read() must consume poll events, not poll()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Tue, May 03, 2022 at 01:27:44PM +0200, Jason A. Donenfeld wrote:
>> On Mon, May 02, 2022 at 05:43:21PM +0200, Lennart Poettering wrote:
>> > On Mo, 02.05.22 17:30, Jason A. Donenfeld (Jason@zx2c4.com) wrote:
>> > 
>> > > Just wanted to double check with you that this change wouldn't break how
>> > > you're using it in systemd for /proc/sys/kernel/hostname:
>> > >
>> > > https://github.com/systemd/systemd/blob/39cd62c30c2e6bb5ec13ebc1ecf0d37ed015b1b8/src/journal/journald-server.c#L1832
>> > > https://github.com/systemd/systemd/blob/39cd62c30c2e6bb5ec13ebc1ecf0d37ed015b1b8/src/resolve/resolved-manager.c#L465
>> > >
>> > > I couldn't find anybody else actually polling on it. Interestingly, it
>> > > looks like sd_event_add_io uses epoll() inside, but you're not hitting
>> > > the bug that Jann pointed out (because I suppose you're not poll()ing on
>> > > an epoll fd).
>> > 
>> > Well, if you made sure this still works, I am fine either way ;-)
>> 
>> Actually... ugh. It doesn't work. systemd uses uname() to read the host
>> name, and doesn't actually read() the file descriptor after receiving
>> the poll event on it. So I guess I'll forget this, and maybe we'll have
>> to live with sysctl's poll() being broken. :(

We should be able to modify calling uname() to act the same as reading
the file descriptor. 

> A kconfig option may let you do what you want, and allow older kernels
> to not break, however I am more curious how sysctl's approach to poll
> went unnnoticed for so long. But also, I'm curious if it was based on
> another poll implementation which may have been busted.
>
> But more importantly, how do we avoid this in the future?

Poll on files is weird and generally doesn't work (because files are
always read to read or write).  What did we do to make it work on these
sysctl files?

Eric
