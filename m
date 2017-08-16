From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Wed, 16 Aug 2017 14:51:42 +0200
Message-ID: <1801152.Iu9ZVUxv1v@tauon.chronox.de>
References: <10436695.bPChAg2egJ@tauon.chronox.de> <5311487.93A5fcTOOn@tauon.chronox.de> <20170815151224.jff5kvmin44lhkot@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1707175.jf7EUlTygQ"
Content-Transfer-Encoding: 7Bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        david.fontaine@capgemini.com, olivier.vivolo@orange.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58922 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdHPMvu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:50 -0400
In-Reply-To: <20170815151224.jff5kvmin44lhkot@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1707175.jf7EUlTygQ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Dienstag, 15. August 2017, 17:12:24 CEST schrieb Theodore Ts'o:

Hi Theodore,

>=20
> Stephan, if you have any comments on the proposal made by David
> Fontaine and Olivier Vivolo, I'd appreciate hearing them!

I think I have some news: The magma code I used for GF(2^32) testing was no=
t=20
correct.

The corrected magma code is attached (thanks to Dr. Peter Birkner, BSI, who=
=20
helped me here).

That magma code shows:

=2D the current polynomials for Q(X) =3D =CE=B1**3 (P(X) =E2=88=92 1) + 1 a=
re irreducible but=20
not primitive over GF(2^32)

=2D the polynomials suggested in https://eprint.iacr.org/2017/726.pdf Q(X) =
=3D=20
=CE=B1**4 (P(X) =E2=88=92 1) + 1 are both, irreducible and primitive over G=
=46(2^32)

The use of GF(2^32) is important, because we apply the LFSR to a 32 bit wor=
d.=20
Hence, we have 2^32 permutations the LFSR should evenly cover.


Bottom line, I would recommend that random.c is patched to take the=20
polynomials suggested in https://eprint.iacr.org/2017/726.pdf.


If it is of any help, the attached magma code could be preserved somewhere=
=20
useful (in random.c?)

Ciao
Stephan
--nextPart1707175.jf7EUlTygQ
Content-Disposition: attachment; filename="LFSR_polynomials eprint 251.mag"
Content-Transfer-Encoding: base64
Content-Type: application/x-wine-extension-mag; name="LFSR_polynomials eprint 251.mag"

Ly8KLy8gTWFnbWEgY29kZSB0byBjaGVjayBMaW51eC1STkcgcG9seW5vbWlhbHMKLy8KLy8gV3Jp
dHRlbiBhbmQgQ29weXJpZ2h0IGJ5OgovLwlEci4gUGV0ZXIgQmlya25lcgovLwlTdGVwaGFuIE11
ZWxsZXIgPHNtdWVsbGVyQGNocm9ub3guZGU+Ci8vCi8vIE1hZ21hIGVtdWxhdG9yOiBodHRwOi8v
bWFnbWEubWF0aHMudXN5ZC5lZHUuYXUvY2FsYy8KCi8vIERlZmluZSBmaW5pdGUgZmllbGQgb2Yg
c2l6ZSAyCkYyIDo9IEZpbml0ZUZpZWxkKDIpOyAgICAgICAgICAgIAoKLy8gRGVmaW5lIGEgcG9s
eW5vbWlhbCByaW5nIG92ZXIgdGhlIGZpbml0ZSBmaWVsZCBvZiBzaXplIDIKUjI8eD4gOj0gUG9s
eW5vbWlhbFJpbmcoRjIpOyAgICAgICAgCgovLyBUaGlzIGlzIHRoZSBDUkMtMzItSUVFRSA4MDIu
MyBwb2x5bm9taWFsIG1lbnRpb25lZCBpbiBTZWN0aW9uIDMuMS4zIHdoaWNoIGNhbiBiZSAKLy8g
Zm91bmQgaW4gaHR0cHM6Ly93d3cueGlsaW54LmNvbS9zdXBwb3J0L2RvY3VtZW50YXRpb24vYXBw
bGljYXRpb25fbm90ZXMveGFwcDIwOS5wZGYKRyA6PSB4XjMyICsgeF4yNiArIHheMjMgKyB4XjIy
ICsgeF4xNiArIHheMTIgKyB4XjExICsgeF4xMCArIHheOCArIHheNyArIHheNSArIHheNCArIHhe
MiArIHggKyAxOyAgCgovLyBDaGVjayBpZiB0aGlzIHBvbHlub21pYWwgaXMgaXJyZWR1Y2libGUu
IEl0IG11c3QgYmUgaXJyZWR1Y2libGUgYmVjYXVzZSBvdGhlcndpc2UgRjMyIHdvdWxkIG5vdCBi
ZSBhIGZpZWxkCnByaW50ICJpcyB0aGUgQ1JDLTMyLUlFRUUgODAyLjMgcG9seW5vbWlhbCBpcnJl
ZHVjaWJsZT8iOwpJc0lycmVkdWNpYmxlKEcpOwoKLy8gRGVmaW5lIHRoZSBmaW5pdGUgZmllbGQg
d2l0aCAyXjMyIGVsZW1lbnRzIHdpdGggZGVmaW5pbmcgcG9seW5vbWlhbCBHIChzZWUgYWJvdmUp
CkYzMiA6PSBleHQ8RjIgfCBHPjsKCi8vIERlZmluZSBhIHBvbHlub21pYWwgcmluZyBvdmVyIHRo
ZSBmaW5pdGUgZmllbGQgRjMyClI8eT4gOj0gUG9seW5vbWlhbFJpbmcoRjMyKTsgCgovLyBhbHBo
YSBpcyB0aGUgcHJpbWl0aXZlIGVsZW1lbnQgb2YgdGhhdCBmaWVsZAphbHBoYSA6PSBQcmltaXRp
dmVFbGVtZW50KEYzMik7CgoKcHJpbnQgIiI7CnByaW50ICJlcHJpbnQgMjUxIHBvbHlub21pYWxz
OiI7CgovLyBEZWZpbmUgdGhlIHBvbHlub21pYWxzIFAgYW5kIFEgYWNjb3JkaW5nIHRvIFNlY3Rp
b24gMy4xLjMgaW4gdGhlIGVwcmludCBwYXBlcgovLyBodHRwOi8vZXByaW50LmlhY3Iub3JnLzIw
MTIvMjUxLnBkZgpQX2lucHV0IDo9IHleMTI4ICsgeV4xMDQgKyB5Xjc2ICsgeV41MSArIHleMjUg
KyB5ICsgMTsKUV9pbnB1dCA6PSBhbHBoYV4zKihQX2lucHV0LTEpKzE7CgpQX291dHB1dCA6PSB5
XjMyICsgeV4yNiArIHleMTkgKyB5XjE0ICsgeV43ICsgeSArIDE7ClFfb3V0cHV0IDo9IGFscGhh
XjMqKFBfaW5wdXQtMSkrMTsKCi8vIENoZWNrIGlmIFEoWCkgaXMgaXJyZWR1Y2libGUKcHJpbnQg
ImlzIFFfaW5wdXQgaXJyZWR1Y2libGU/IjsKSXNJcnJlZHVjaWJsZShRX2lucHV0KTsKcHJpbnQg
ImlzIFFfb3V0cHV0IGlycmVkdWNpYmxlPyI7CklzSXJyZWR1Y2libGUoUV9vdXRwdXQpOwoKLy8g
RGl2aWRlIFEoeCkgYnkgaXRzIGxlYWRpbmcgY29lZmZpY2llbnQgdG8gbWFrZSBpdCBtb25pYy4g
T25seSB0aGVuIGl0IGNhbiBiZSB0ZXN0ZWQgZm9yIHByaW1pdGl2aXR5CnByaW50ICJpcyBRX2lu
cHV0IHByaW1pdGl2ZT8iOwpsIDo9IExlYWRpbmdDb2VmZmljaWVudChRX2lucHV0KTsKSXNQcmlt
aXRpdmUoUV9pbnB1dC9sKTsKcHJpbnQgImlzIFFfb3V0cHV0IHByaW1pdGl2ZT8iOwpsIDo9IExl
YWRpbmdDb2VmZmljaWVudChRX291dHB1dCk7CklzUHJpbWl0aXZlKFFfb3V0cHV0L2wpOwoKCnBy
aW50ICIiOwpwcmludCAiZXByaW50IDcyNiBwb2x5bm9taWFsczoiOwoKLy8gRGVmaW5lIHRoZSBw
b2x5bm9taWFscyBQIGFuZCBRIGFjY29yZGluZyB0byBTZWN0aW9uIDIgaW4gdGhlIGVwcmludCBw
YXBlcgovLyBodHRwczovL2VwcmludC5pYWNyLm9yZy8yMDE3LzcyNi5wZGYKUF9pbnB1dCA6PSB5
XjEyOCArIHleMTA2ICsgeV43OSArIHleNTEgKyB5XjI1ICsgeSArIDE7ClFfaW5wdXQgOj0gYWxw
aGFeNCooUF9pbnB1dC0xKSsxOwoKUF9vdXRwdXQgOj0geV4zMiArIHleMjcgKyB5XjIxICsgeV4x
NCArIHleNyArIHkgKyAxOwpRX291dHB1dCA6PSBhbHBoYV40KihQX291dHB1dC0xKSsxOwoKLy8g
Q2hlY2sgaWYgUShYKSBpcyBpcnJlZHVjaWJsZQpwcmludCAiaXMgUV9pbnB1dCBpcnJlZHVjaWJs
ZT8iOwpJc0lycmVkdWNpYmxlKFFfaW5wdXQpOwpwcmludCAiaXMgUV9vdXRwdXQgaXJyZWR1Y2li
bGU/IjsKSXNJcnJlZHVjaWJsZShRX291dHB1dCk7CgovLyBEaXZpZGUgUSh4KSBieSBpdHMgbGVh
ZGluZyBjb2VmZmljaWVudCB0byBtYWtlIGl0IG1vbmljLiBPbmx5IHRoZW4gaXQgY2FuIGJlIHRl
c3RlZCBmb3IgcHJpbWl0aXZpdHkKcHJpbnQgImlzIFFfaW5wdXQgcHJpbWl0aXZlPyI7CmwgOj0g
TGVhZGluZ0NvZWZmaWNpZW50KFFfaW5wdXQpOwpJc1ByaW1pdGl2ZShRX2lucHV0L2wpOwoKcHJp
bnQgImlzIFFfb3V0cHV0IHByaW1pdGl2ZT8iOwpsIDo9IExlYWRpbmdDb2VmZmljaWVudChRX291
dHB1dCk7CklzUHJpbWl0aXZlKFFfb3V0cHV0L2wpOwoK


--nextPart1707175.jf7EUlTygQ--
