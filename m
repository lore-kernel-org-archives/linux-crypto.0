From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/3] crypto: add output feedback mode
Date: Fri, 28 Sep 2018 18:27:13 +0300
Message-ID: <CAOtvUMd68Bv7O8za5CLn7SGSgCDyR0fEE3MFU+5MfhfVBd2WHw@mail.gmail.com>
References: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
 <1537449521-16182-3-git-send-email-gilad@benyossef.com> <CAKv+Gu9T7Z2oV8TEaN8uVdrFxGmmCKLh6ZjDnRnhgCmLwuVf4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9T7Z2oV8TEaN8uVdrFxGmmCKLh6ZjDnRnhgCmLwuVf4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Fri, Sep 28, 2018 at 1:06 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 20 September 2018 at 15:18, Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
> > Add a generic version of output feedback mode. We already have support =
of
> > several hardware based transformations of this mode and the needed test
> > vectors but we somehow missed adding a generic software one. Fix this n=
ow.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> I couldn't find any users of OFB in the kernel. Any idea who is using
> it and for what?

Most probably nothing in-kernel, as there was no generic software
implementation up till now and no one complained. :-)
It is available via the user space crpto API *if* you happened to have
supporting hardware, which is a very odd situation.

The kernel has test vectors for OFB for DES, 3DES and AES. We have
multiple HW based implementation registering
and making available their support for this mode for some time now,
but not software implementation and probably no in kernel users.

Had we have no support for it in the kernel at, I wouldn't have
offered a generic software implementation, but since
we do and have for some time supported using this operation mode (but
only if you have supporting HW), it seems
we are in a strange limbo position and should go to either removing
all support or adding generic support - hence my patch.


Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
