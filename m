From: Fontaine david <fontained35@gmail.com>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Wed, 16 Aug 2017 20:59:54 +0200
Message-ID: <CACCXZ7qB8+iovWSLG31K6DOm_16W0YDRJad+rXab7-uK7_vOcA@mail.gmail.com>
References: <10436695.bPChAg2egJ@tauon.chronox.de> <5311487.93A5fcTOOn@tauon.chronox.de>
 <20170815151224.jff5kvmin44lhkot@thunk.org> <1801152.Iu9ZVUxv1v@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "FONTAINE, David" <david.fontaine@capgemini.com>,
        Olivier Vivolo <olivier.vivolo@orange.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1801152.Iu9ZVUxv1v@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Sorry to answer this late, but i was pretty busy, and i assume Olivier
Vivolo is on vacation.

For a polynomial, being primitive implies being irreducible, and the
polynomial which must be primitive is Q(x), as you described it
earlier, on GF(2^32).
When the polynomials will be primitive,the TGFSR (LFSR on 32 bit word)
will have his maximal period.
If i remember well, we gived inthe paper, the magma code, and the
patch for random.c.
We did several tests for the propsal, and we chose those polynomials
because they avoid a lot of changes on the source code, and they
preserve the quality of the statistic distribution.


Regards,
David.


2017-08-16 14:51 GMT+02:00 Stephan Mueller <smueller@chronox.de>:
> Am Dienstag, 15. August 2017, 17:12:24 CEST schrieb Theodore Ts'o:
>
> Hi Theodore,
>
>>
>> Stephan, if you have any comments on the proposal made by David
>> Fontaine and Olivier Vivolo, I'd appreciate hearing them!
>
> I think I have some news: The magma code I used for GF(2^32) testing was =
not
> correct.
>
> The corrected magma code is attached (thanks to Dr. Peter Birkner, BSI, w=
ho
> helped me here).
>
> That magma code shows:
>
> - the current polynomials for Q(X) =3D =CE=B1**3 (P(X) =E2=88=92 1) + 1 a=
re irreducible but
> not primitive over GF(2^32)
>
> - the polynomials suggested in https://eprint.iacr.org/2017/726.pdf Q(X) =
=3D
> =CE=B1**4 (P(X) =E2=88=92 1) + 1 are both, irreducible and primitive over=
 GF(2^32)
>
> The use of GF(2^32) is important, because we apply the LFSR to a 32 bit w=
ord.
> Hence, we have 2^32 permutations the LFSR should evenly cover.
>
>
> Bottom line, I would recommend that random.c is patched to take the
> polynomials suggested in https://eprint.iacr.org/2017/726.pdf.
>
>
> If it is of any help, the attached magma code could be preserved somewher=
e
> useful (in random.c?)
>
> Ciao
> Stephan
