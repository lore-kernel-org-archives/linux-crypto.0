From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.6-rc5
Date: Sun, 9 Sep 2012 08:35:56 -0700
Message-ID: <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com> <20120909155424.862635h7ncykg9s0@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Romain Francoise <romain@orebokech.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120909155424.862635h7ncykg9s0@www.81.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 9, 2012 at 5:54 AM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
>
> Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?
>
> That commit added crypto selftest for authenc(hmac(sha1),cbc(aes)) in 3.6,
> and probably made this bug visible (but not directly causing it).

So Romain said it does - where do we go from here? Revert testing it,
or fix the authenc() case? I'd prefer the fix..

                 Linus
