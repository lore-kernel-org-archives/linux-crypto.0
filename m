From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: limit build to plausible archs
Date: Tue, 24 Apr 2018 16:44:28 +0300
Message-ID: <CAOtvUMc5-UC1im7TYt7AtRJMJY=+_mRNmugWPNL_R_twLf7CQA@mail.gmail.com>
References: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
 <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
 <CAOtvUMd41+5DzHRbViyNZkiL92BYh2YaREvhiAH0UPnPYCzB+w@mail.gmail.com>
 <CAMuHMdXZ0vL7Rxg4+CsP1u_Eb95Nj+qHnrahYPhAewmcrxN9HQ@mail.gmail.com>
 <CAOtvUMe=iOeWAUwDQ-3yy=Ogg0_=4iEwV32ATEn6SrLPEojNGQ@mail.gmail.com> <CAMuHMdWQAss+_fjrj5BGcstojR0Up9-danH3UxC5PWOLkKrpXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWQAss+_fjrj5BGcstojR0Up9-danH3UxC5PWOLkKrpXQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 24, 2018 at 11:52 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

>
> My underlying idea is not to cut down build time for test code (that's what
> we have COMPILE_TEST for), but to enhance usability for users and distros,
> who need to know if it makes sense to enable an option.

OK, considering the driver Kconfig depends on OF I think we're OK here
with regard to usability and distros.

>
> IMHO the extensive list of possible architectures is not really an
> improvement. So either a dependency on COMPILE_TEST, or no dependency
> at all makes the most sense to me.

Fair enough. Herbert, please drop the  patch than.

Thanks!
Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
