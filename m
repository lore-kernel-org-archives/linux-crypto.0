From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v2.2 1/7] crypto: GnuPG based MPI lib - source files (part 1)
Date: Mon, 21 Nov 2011 12:20:33 +0200
Message-ID: <CALLzPKZ70YWb45k+8Z6ApH5MuN7HwBBTWbLcu-UtRkFU07cwmg@mail.gmail.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
	<20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.apana.org.au, James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 19, 2011 at 5:33 AM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> Hi all,
>
> On Wed, 19 Oct 2011 14:51:30 +0300 Dmitry Kasatkin <dmitry.kasatkin@i=
ntel.com> wrote:
>>
>> Adds the multi-precision-integer maths library which was originally =
taken
>> from GnuPG and ported to the kernel by (among others) David Howells.
>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>> The difference is that checkpatch reported errors and warnings have =
been fixed.
>>
>> This library is used to implemenet RSA digital signature verificatio=
n
>> used in IMA/EVM integrity protection subsystem.
>>
>> Due to patch size limitation, the patch is divided into 4 parts.
>
> I just noticed that this has been added to the "next" branch of the
> security tree (and thus into the next release of linux-next). =C2=A0I=
 think
> that these patches should be rearranged as in their current form, the=
y
> break bisection (since the files in this patch reference include file=
s in
> a latter patch). =C2=A0 We generally prefer large patches to be broke=
n up into
> logical sub patches rather than just along file boundaries.
>
> In this case, even though it was broken up for review, it could have =
been
> committed as one large commit (assuming that there is no sensible way=
 to
> break it up).

Hi,

It can be easily split into 2 commits and one of them would not comply
with mailing list limits.

James, should I do anything about it?

Thanks,

- Dmitry

> --
> Cheers,
> Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
