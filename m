From: Kees Cook <keescook@chromium.org>
Subject: Re: race condition in crypto larval handling
Date: Sun, 8 Sep 2013 08:52:11 -0700
Message-ID: <CAGXu5jLQ8oex=PMftRsFcoB78SXSRM3LTVoib61agA392vSvTA@mail.gmail.com>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com>
	<20130908013210.GA30627@gondor.apana.org.au>
	<CAGXu5j+DoXK_9v430xhCzOO1bsuuhe84fjkf7+DZ0r35hUNBBg@mail.gmail.com>
	<20130908043703.GA31554@gondor.apana.org.au>
	<20130908045422.GA31896@gondor.apana.org.au>
	<CAGXu5jL4ojFEWAkW0NDSERUFTQhPgwb6ToOcAsg_4QySex1GfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Tyler Hicks <tyhicks@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41547 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3IHPwM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Sep 2013 11:52:12 -0400
Received: by mail-oa0-f53.google.com with SMTP id k18so5658231oag.40
        for <linux-crypto@vger.kernel.org>; Sun, 08 Sep 2013 08:52:12 -0700 (PDT)
In-Reply-To: <CAGXu5jL4ojFEWAkW0NDSERUFTQhPgwb6ToOcAsg_4QySex1GfA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 7, 2013 at 11:01 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Sep 7, 2013 at 9:54 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Sun, Sep 08, 2013 at 02:37:03PM +1000, Herbert Xu wrote:
>>> On Sat, Sep 07, 2013 at 08:34:15PM -0700, Kees Cook wrote:
>>> >
>>> > However, I noticed on the "good" path (even without the above patch),
>>> > I sometimes see a double-kfree triggered by the modprobe process. I
>>> > can't, however, see how that's happening, since larval_destroy should
>>> > only be called when refcnt == 0.
>>>
>>> Do you still see this double free with this patch? Without the
>>> patch it is completely expected as killing the same lavral twice
>>> will cause memory corruption leading to all sorts of weirdness,
>>> even if you stop it from deleting the list entry twice.
>>
>> Actually I know what it is.  sha512 registers two algorithms.
>> Therefore, it will create two larvals in sequence and then destroy
>> them in turn.  So it's not a double free at all.  If you put a
>> printk in crypto_larval_alloc that should confirm this.
>
> Ah! That would make sense; it just happens to re-allocate to the exact
> same location, yes. Whew, that's certainly what's happening. I can
> retest to confirm in my morning.

Confirmed: 2 allocs happen, and then 2 kfrees. :)

-Kees

-- 
Kees Cook
Chrome OS Security
