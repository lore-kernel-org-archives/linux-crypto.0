From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 00/11] getting back -Wmaybe-uninitialized
Date: Fri, 11 Nov 2016 09:13:00 -0800
Message-ID: <CA+55aFx_scFVFKU__TBmoffw_iHvrdAU2dj5u1WKfWJXAkS4QA@mail.gmail.com>
References: <20161110164454.293477-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>,
        Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Ley Foon Tan <lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org>,
        "Luis R . Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,
        Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Michal Marek <mmarek-IBi9RG/b67k@public.gmane.org>,
        Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Sean Young <sean-hENCXIMQXOg@public.gmane.org>,
        Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
        "the arch/x86 maintainers" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Linux Kbuild mailing list <linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        sayli karnik <karniksayli1995-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161110164454.293477-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 10, 2016 at 8:44 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>
> Please merge these directly if you are happy with the result.

I will take this.

I do see two warnings, but they both seem to be valid and recent,
though, so I have no issues with the spurious cases.

Warning #1:

  sound/soc/qcom/lpass-platform.c: In function =E2=80=98lpass_platform_pcmo=
ps_open=E2=80=99:
  sound/soc/qcom/lpass-platform.c:83:29: warning: =E2=80=98dma_ch=E2=80=99 =
may be used
uninitialized in this function [-Wmaybe-uninitialized]
    drvdata->substream[dma_ch] =3D substream;
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~

and 'dma_ch' usage there really is crazy and wrong. Broken by
022d00ee0b55 ("ASoC: lpass-platform: Fix broken pcm data usage")

Warning #2 is not a real bug, but it's reasonable that gcc doesn't
know that storage_bytes (chip->read_size) has to be 2/4. Again,
introduced recently by commit 231147ee77f3 ("iio: maxim_thermocouple:
Align 16 bit big endian value of raw reads"), so you didn't see it.

  drivers/iio/temperature/maxim_thermocouple.c: In function
=E2=80=98maxim_thermocouple_read_raw=E2=80=99:
  drivers/iio/temperature/maxim_thermocouple.c:141:5: warning: =E2=80=98ret=
=E2=80=99
may be used uninitialized in this function [-Wmaybe-uninitialized]
    if (ret)
       ^
  drivers/iio/temperature/maxim_thermocouple.c:128:6: note: =E2=80=98ret=E2=
=80=99 was
declared here
    int ret;
        ^~~

and I guess that code can just initialize 'ret' to '-EINVAL' or
something to just make the theoretical "somehow we had a wrong
chip->read_size" case error out cleanly.

                Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
