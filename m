From: Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] orinoco: Use shash instead of ahash for MIC calculations
Date: Tue, 13 Dec 2016 19:03:53 +0200
Message-ID: <87eg1bzrpi.fsf@kamboji.qca.qualcomm.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
        <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
        <87mvg0kqno.fsf@purkki.adurom.net>
        <CALCETrXxQ9FxuqV5A1rkj2SpeFfd89njDP9h5VBuNx387ieKdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Wireless List <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXxQ9FxuqV5A1rkj2SpeFfd89njDP9h5VBuNx387ieKdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Andy Lutomirski's message of "Tue, 13 Dec 2016 08:41:01 -0800")
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Tue, Dec 13, 2016 at 3:35 AM, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>> Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
>>
>>> Eric Biggers pointed out that the orinoco driver pointed scatterlists
>>> at the stack.
>>>
>>> Fix it by switching from ahash to shash.  The result should be
>>> simpler, faster, and more correct.
>>>
>>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.9 only
>>> Reported-by: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>> "more correct"? Does this fix a real user visible bug or what? And why
>> just stable 4.9, does this maybe have something to do with
>> CONFIG_VMAP_STACK?
>
> Whoops, I had that text in some other patches but forgot to put it in
> this one.  It'll blow up with CONFIG_VMAP_STACK=y if a debug option
> like CONFIG_DEBUG_VIRTUAL=y is set.  It may work by accident if
> debugging is off.

Makes sense now, thanks. I'll add that to the commit log and queue this
to 4.10.

-- 
Kalle Valo
