From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:02:13 +0100
Message-ID: <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <20081207174435.GB1687@ioremap.net>
	 <20081207175245.2d074299@lxorguk.ukuu.org.uk>
	 <20081207175438.GA3181@ioremap.net>
	 <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	 <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	 <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:31609 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYLGTCP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 14:02:15 -0500
Received: by ey-out-2122.google.com with SMTP id 6so327198eyi.37
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 11:02:14 -0800 (PST)
In-Reply-To: <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 19:31, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > The loop is detected and terminated.
>>
>> No. Please back up what you are trying to talk about.
>
> Let me introduce you to.. drum roll.. the source code. Its a useful
> resource, why don't you use it for once.
>
>
>        max_modprobes = min(max_threads/2, MAX_KMOD_CONCURRENT);
>        atomic_inc(&kmod_concurrent);
>        if (atomic_read(&kmod_concurrent) > max_modprobes) {
>                /* We may be blaming an innocent here, but unlikely */
>                if (kmod_loop_msg++ < 5)
>                        printk(KERN_ERR
>                               "request_module: runaway loop modprobe
> %s\n", module_name);
>                atomic_dec(&kmod_concurrent);
>                return -ENOMEM;
>        }
>
> Happy now. Print it out, share it with friends, find someone who can read
> C if you are stuck.

It does not work, that's all. Reproduce the bug and look at it for yourself.

It's still a bug, regardless of all the childish stuff you wrap around it.

>> The boxes of the reporters hang! Read the bug! Please!
>
> They would still hang. As I repeatedly said for the benefit of two people
> who don't seem to be able to read source code, the loop is detected and
> terminated. So it already fails the open when it sees it has gotten five
> layers deep.
>
>> There is no cheap way out of the problem, it's a kernel bug, and we
>> will fix it - you may just delay it with your zero arguments.
>
> Oh I see. Allow me to explain your position in the words of some small
> children I know
>
>        "ME!! ME!! ME!! ME!! ME!!"
>
> I don't care about your obscure corner-case non bug that in fact was a
> crypto bug combined with a modprobe bug and where the crypto bug is
> now fixed. I do care about not breaking existing users systems. The fact
> we do this is why Linux doesn't suck.

It's not obscure, it's obviously broken. And it currently sucks.

I have no idea why are you repeatedly, with completely wrong arguments
trying, to explain "hotplug" stuff to me. I maintain it by the way,
and I didn't see you involved here in the last years, so I guess you
miss the background to understand the problem.

Kay
