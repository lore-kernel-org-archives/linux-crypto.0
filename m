From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: Possible bug in CTR (and Salsa20) for large test vectors
Date: Sun, 25 Nov 2007 23:58:15 +0800
Message-ID: <fd3e431c0711250758k6cbfa13fja73f5298a4c356f4@mail.gmail.com>
References: <fd3e431c0711241207u462cacdfre0ca957cd16a6b58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5087_12701795.1196006295467"
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:63451 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXKYP6Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 10:58:16 -0500
Received: by an-out-0708.google.com with SMTP id d31so54535and
        for <linux-crypto@vger.kernel.org>; Sun, 25 Nov 2007 07:58:15 -0800 (PST)
In-Reply-To: <fd3e431c0711241207u462cacdfre0ca957cd16a6b58@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

------=_Part_5087_12701795.1196006295467
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

It seems the CTR bug is due to crypto_ctr_crypt_inplace() and
crypto_ctr_crypt_segment() always returning 0. For the 4096 bytes test
case I previously described, they should return 8 when walk.nbytes =
4008 and refrain from processing the last 8 bytes. (This is based on
my current understanding of blkcipher. I may be wrong.)

To resolve it, I added a "remain" parameter to both
crypto_ctr_crypt_inplace() and crypto_ctr_crypt_segment(). This
"remain" parameter represents a remainder modulo bsize. When "remain"
is zero, both functions encrypt the full walk.nbytes data. When
"remain" is positive, both functions encrypt up to the block boundary
(i.e. walk.nbytes - walk.nbytes % bsize) and leave the "remain"-ing
bytes for the next loop.

The nbytes parameter in crypto_ctr_crypt() is used to keep track of
how many bytes have been processed so far. If walk.nbytes >= nbytes,
we know it is the last few blocks and hence we can set "remain" to 0.
Else we set "remain" to walk.nbytes % bsize.

Attached is the patch for ctr.c. (Note that it is against commit
19f4711b7a8f4bf5457a52873f82985a3762cd48 as I am having problems with
the latest givcipher patches on UML. Sorry about that.)

Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>
---
By the way, such an approach is useful for Salsa20 too as eSTREAM
provided encrypt_blocks() and encrypt_bytes() APIsl, which is
essentially what I am trying to simulate with the "remain" parameter.



On Nov 25, 2007 4:07 AM, Tan Swee Heng <thesweeheng@gmail.com> wrote:
> I seem to have encountered a bug when encrypting large test vectors.
>
> TEST SETTINGS
> I modified tcrypt.c to "ctr(aes,4,8,4)"-encrypt a single large test
> vector defined as:
>    plaintext = 00...00 (4096 bytes)
>    key = 00...00 (32 bytes)
>    nonce = 00...00 (4 bytes)
>    iv = 00...00 (8 bytes)
>    counter = 4 bytes starting from 00...01.
>
> OUTPUT
> The output I obtained (using a modified hexdump() in tcrypt.c) is this:
>   3992 : e2 0e 5f 84 e9 05 ea 8f
>   4000 : 75 f7 2a ac 4f e9 70 12
>   4008 : 80 88 db 7a 50 0b 22 cd
>   4016 : 2d 23 c8 d1 90 8b 43 14
>   4024 : ae 69 5c 8a 49 ba e9 74
>   4032 : 71 2a 62 a2 14 14 df 86
>   4040 : a6 4c 51 5d 9a cc c3 9e
>   4048 : cd e5 24 14 68 8e 5b f6
>   4056 : 4d 4f 06 c6 f1 7c 29 03
>   4064 : ab c7 50 b2 8e da 2e 34
>   4072 : c7 e9 d2 50 99 86 32 d4
>   4080 : 44 35 62 42 ef 04 05 8d
>   4088 : 4c af 3c 8e be b9 f2 48
>
> Compare with what I obtained using Crypto++:
>   3992 : e2 0e 5f 84 e9 05 ea 8f
>   4000 : 75 f7 2a ac 4f e9 70 12
>   4008 : 67 3e 05 ba c1 56 20 99
>   4016 : 80 88 db 7a 50 0b 22 cd
>   4024 : 2d 23 c8 d1 90 8b 43 14
>   4032 : ae 69 5c 8a 49 ba e9 74
>   4040 : 71 2a 62 a2 14 14 df 86
>   4048 : a6 4c 51 5d 9a cc c3 9e
>   4056 : cd e5 24 14 68 8e 5b f6
>   4064 : 4d 4f 06 c6 f1 7c 29 03
>   4072 : ab c7 50 b2 8e da 2e 34
>   4080 : c7 e9 d2 50 99 86 32 d4
>   4088 : 44 35 62 42 ef 04 05 8d
>
> As we can see, half a block (8 bytes) went "missing" at the start of byte 4008.
>
> DIAGNOSIS
> I added a prink() after "while (walk.nbytes)" in crypto_ctr_crypt().
> On my system, it shows that the 4096 bytes buffer is broken into two
> parts such that the first walk.nbytes = 4008 and the second
> walk.nbytes = 88. Since 4008 % 16 = 8, therefore bytes 4000 to 4007
> are XORed with the first 8 bytes of AES(counter N). The remaining 8
> bytes of AES(counter N) are still available and are meant for bytes
> 4008 to 4015. However they are discarded when N is incremented. Thus
> when the 2nd part is encrypted, byte 4008 to 4015 are XORed with the
> first 8 bytes of AES(counter N+1) instead. The rest of the stream
> slips as a result of this.
>
> RESOLUTION
> One idea is to keep state on how many bytes in the AES(counter N)
> buffer has been consumed so that N is not incremented unnecessarily.
> But there may be inefficiencies associated with these additional
> checks. If anyone has better ideas, please feel free to post it. (Note
> that salsa20_generic.c has the same problem. So any great ideas for
> CTR would be useful to me too. :-)
>
> Swee Heng
>

------=_Part_5087_12701795.1196006295467
Content-Type: text/plain; name=patch1-ctr.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9fr5efx1
Content-Disposition: attachment; filename=patch1-ctr.txt

ZGlmZiAtLWdpdCBhL2NyeXB0by9jdHIuYyBiL2NyeXB0by9jdHIuYwppbmRleCBiOTc0YTlmLi41
NTBjNDRlIDEwMDY0NAotLS0gYS9jcnlwdG8vY3RyLmMKKysrIGIvY3J5cHRvL2N0ci5jCkBAIC0x
MDYsNyArMTA2LDggQEAgc3RhdGljIGludCBjcnlwdG9fY3RyX3NldGtleShzdHJ1Y3QgY3J5cHRv
X3RmbSAqcGFyZW50LCBjb25zdCB1OCAqa2V5LAogCiBzdGF0aWMgaW50IGNyeXB0b19jdHJfY3J5
cHRfc2VnbWVudChzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsgKndhbGssCiAJCQkJICAgIHN0cnVjdCBj
cnlwdG9fY2lwaGVyICp0Zm0sIHU4ICpjdHJibGssCi0JCQkJICAgIHVuc2lnbmVkIGludCBjb3Vu
dGVyc2l6ZSkKKwkJCQkgICAgdW5zaWduZWQgaW50IGNvdW50ZXJzaXplLAorCQkJCSAgICB1bnNp
Z25lZCBpbnQgcmVtYWluKQogewogCXZvaWQgKCpmbikoc3RydWN0IGNyeXB0b190Zm0gKiwgdTgg
KiwgY29uc3QgdTggKikgPQogCQkgICBjcnlwdG9fY2lwaGVyX2FsZyh0Zm0pLT5jaWFfZW5jcnlw
dDsKQEAgLTExNiw5ICsxMTcsMTIgQEAgc3RhdGljIGludCBjcnlwdG9fY3RyX2NyeXB0X3NlZ21l
bnQoc3RydWN0IGJsa2NpcGhlcl93YWxrICp3YWxrLAogCXU4ICprZXlzdHJlYW0gPSAodTggKilB
TElHTigodW5zaWduZWQgbG9uZylrcywgYWxpZ25tYXNrICsgMSk7CiAJdTggKnNyYyA9IHdhbGst
PnNyYy52aXJ0LmFkZHI7CiAJdTggKmRzdCA9IHdhbGstPmRzdC52aXJ0LmFkZHI7Ci0JdW5zaWdu
ZWQgaW50IG5ieXRlcyA9IHdhbGstPm5ieXRlczsKKwl1bnNpZ25lZCBpbnQgbmJ5dGVzID0gd2Fs
ay0+bmJ5dGVzIC0gcmVtYWluOwogCiAJZG8geworCQkvKiBpbmNyZW1lbnQgY291bnRlciBpbiBj
b3VudGVyYmxvY2sgKi8KKwkJY3RyX2luY19xdWFkKGN0cmJsayArIChic2l6ZSAtIGNvdW50ZXJz
aXplKSwgY291bnRlcnNpemUpOworCiAJCS8qIGNyZWF0ZSBrZXlzdHJlYW0gKi8KIAkJZm4oY3J5
cHRvX2NpcGhlcl90Zm0odGZtKSwga2V5c3RyZWFtLCBjdHJibGspOwogCQl4b3JfcXVhZChrZXlz
dHJlYW0sIHNyYywgbWluKG5ieXRlcywgYnNpemUpKTsKQEAgLTEyNiw5ICsxMzAsNiBAQCBzdGF0
aWMgaW50IGNyeXB0b19jdHJfY3J5cHRfc2VnbWVudChzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsgKndh
bGssCiAJCS8qIGNvcHkgcmVzdWx0IGludG8gZHN0ICovCiAJCW1lbWNweShkc3QsIGtleXN0cmVh
bSwgbWluKG5ieXRlcywgYnNpemUpKTsKIAotCQkvKiBpbmNyZW1lbnQgY291bnRlciBpbiBjb3Vu
dGVyYmxvY2sgKi8KLQkJY3RyX2luY19xdWFkKGN0cmJsayArIChic2l6ZSAtIGNvdW50ZXJzaXpl
KSwgY291bnRlcnNpemUpOwotCiAJCWlmIChuYnl0ZXMgPCBic2l6ZSkKIAkJCWJyZWFrOwogCkBA
IC0xNDMsMjUgKzE0NCwyNiBAQCBzdGF0aWMgaW50IGNyeXB0b19jdHJfY3J5cHRfc2VnbWVudChz
dHJ1Y3QgYmxrY2lwaGVyX3dhbGsgKndhbGssCiAKIHN0YXRpYyBpbnQgY3J5cHRvX2N0cl9jcnlw
dF9pbnBsYWNlKHN0cnVjdCBibGtjaXBoZXJfd2FsayAqd2FsaywKIAkJCQkgICAgc3RydWN0IGNy
eXB0b19jaXBoZXIgKnRmbSwgdTggKmN0cmJsaywKLQkJCQkgICAgdW5zaWduZWQgaW50IGNvdW50
ZXJzaXplKQorCQkJCSAgICB1bnNpZ25lZCBpbnQgY291bnRlcnNpemUsCisJCQkJICAgIHVuc2ln
bmVkIGludCByZW1haW4pCiB7CiAJdm9pZCAoKmZuKShzdHJ1Y3QgY3J5cHRvX3RmbSAqLCB1OCAq
LCBjb25zdCB1OCAqKSA9CiAJCSAgIGNyeXB0b19jaXBoZXJfYWxnKHRmbSktPmNpYV9lbmNyeXB0
OwogCXVuc2lnbmVkIGludCBic2l6ZSA9IGNyeXB0b19jaXBoZXJfYmxvY2tzaXplKHRmbSk7CiAJ
dW5zaWduZWQgbG9uZyBhbGlnbm1hc2sgPSBjcnlwdG9fY2lwaGVyX2FsaWdubWFzayh0Zm0pOwot
CXVuc2lnbmVkIGludCBuYnl0ZXMgPSB3YWxrLT5uYnl0ZXM7CisJdW5zaWduZWQgaW50IG5ieXRl
cyA9IHdhbGstPm5ieXRlcyAtIHJlbWFpbjsKIAl1OCAqc3JjID0gd2Fsay0+c3JjLnZpcnQuYWRk
cjsKIAl1OCBrc1tic2l6ZSArIGFsaWdubWFza107CiAJdTggKmtleXN0cmVhbSA9ICh1OCAqKUFM
SUdOKCh1bnNpZ25lZCBsb25nKWtzLCBhbGlnbm1hc2sgKyAxKTsKIAogCWRvIHsKLQkJLyogY3Jl
YXRlIGtleXN0cmVhbSAqLwotCQlmbihjcnlwdG9fY2lwaGVyX3RmbSh0Zm0pLCBrZXlzdHJlYW0s
IGN0cmJsayk7Ci0JCXhvcl9xdWFkKHNyYywga2V5c3RyZWFtLCBtaW4obmJ5dGVzLCBic2l6ZSkp
OwotCiAJCS8qIGluY3JlbWVudCBjb3VudGVyIGluIGNvdW50ZXJibG9jayAqLwogCQljdHJfaW5j
X3F1YWQoY3RyYmxrICsgKGJzaXplIC0gY291bnRlcnNpemUpLCBjb3VudGVyc2l6ZSk7CiAKKwkJ
LyogY3JlYXRlIGtleXN0cmVhbSAqLworCQlmbihjcnlwdG9fY2lwaGVyX3RmbSh0Zm0pLCBrZXlz
dHJlYW0sIGN0cmJsayk7CisJCXhvcl9xdWFkKHNyYywga2V5c3RyZWFtLCBic2l6ZSk7CisKIAkJ
aWYgKG5ieXRlcyA8IGJzaXplKQogCQkJYnJlYWs7CiAKQEAgLTE4OCw2ICsxOTAsNyBAQCBzdGF0
aWMgaW50IGNyeXB0b19jdHJfY3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNjICpkZXNjLAogCXU4
IGNibGtbYnNpemUgKyBhbGlnbm1hc2tdOwogCXU4ICpjb3VudGVyYmxrID0gKHU4ICopQUxJR04o
KHVuc2lnbmVkIGxvbmcpY2JsaywgYWxpZ25tYXNrICsgMSk7CiAJaW50IGVycjsKKwl1bnNpZ25l
ZCBpbnQgcmVtYWluOwogCiAJYmxrY2lwaGVyX3dhbGtfaW5pdCgmd2FsaywgZHN0LCBzcmMsIG5i
eXRlcyk7CiAJZXJyID0gYmxrY2lwaGVyX3dhbGtfdmlydF9ibG9jayhkZXNjLCAmd2FsaywgYnNp
emUpOwpAQCAtMTk3LDIxICsyMDAsMjAgQEAgc3RhdGljIGludCBjcnlwdG9fY3RyX2NyeXB0KHN0
cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywKIAltZW1jcHkoY291bnRlcmJsaywgY3R4LT5ub25j
ZSwgaWN0eC0+bm9uY2VzaXplKTsKIAltZW1jcHkoY291bnRlcmJsayArIGljdHgtPm5vbmNlc2l6
ZSwgd2Fsay5pdiwgaWN0eC0+aXZzaXplKTsKIAotCS8qIGluaXRpYWxpemUgY291bnRlciBwb3J0
aW9uIG9mIGNvdW50ZXIgYmxvY2sgKi8KLQljdHJfaW5jX3F1YWQoY291bnRlcmJsayArIChic2l6
ZSAtIGljdHgtPmNvdW50ZXJzaXplKSwKLQkJICAgICBpY3R4LT5jb3VudGVyc2l6ZSk7Ci0KIAl3
aGlsZSAod2Fsay5uYnl0ZXMpIHsKKwkJcmVtYWluID0gKHdhbGsubmJ5dGVzID49IG5ieXRlcykg
PyAwIDogKHdhbGsubmJ5dGVzICUgYnNpemUpOworCQluYnl0ZXMgLT0gKHdhbGsubmJ5dGVzIC0g
cmVtYWluKTsKKwkJCQogCQlpZiAod2Fsay5zcmMudmlydC5hZGRyID09IHdhbGsuZHN0LnZpcnQu
YWRkcikKLQkJCW5ieXRlcyA9IGNyeXB0b19jdHJfY3J5cHRfaW5wbGFjZSgmd2FsaywgY2hpbGQs
Ci0JCQkJCQkJICBjb3VudGVyYmxrLAotCQkJCQkJCSAgaWN0eC0+Y291bnRlcnNpemUpOworCQkJ
Y3J5cHRvX2N0cl9jcnlwdF9pbnBsYWNlKCZ3YWxrLCBjaGlsZCwKKwkJCQkJCSBjb3VudGVyYmxr
LAorCQkJCQkJIGljdHgtPmNvdW50ZXJzaXplLCByZW1haW4pOwogCQllbHNlCi0JCQluYnl0ZXMg
PSBjcnlwdG9fY3RyX2NyeXB0X3NlZ21lbnQoJndhbGssIGNoaWxkLAotCQkJCQkJCSAgY291bnRl
cmJsaywKLQkJCQkJCQkgIGljdHgtPmNvdW50ZXJzaXplKTsKKwkJCWNyeXB0b19jdHJfY3J5cHRf
c2VnbWVudCgmd2FsaywgY2hpbGQsCisJCQkJCQkgY291bnRlcmJsaywKKwkJCQkJCSBpY3R4LT5j
b3VudGVyc2l6ZSwgcmVtYWluKTsKIAotCQllcnIgPSBibGtjaXBoZXJfd2Fsa19kb25lKGRlc2Ms
ICZ3YWxrLCBuYnl0ZXMpOworCQllcnIgPSBibGtjaXBoZXJfd2Fsa19kb25lKGRlc2MsICZ3YWxr
LCByZW1haW4pOwogCX0KIAlyZXR1cm4gZXJyOwogfQo=
------=_Part_5087_12701795.1196006295467--
