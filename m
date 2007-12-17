From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/2] Salsa20 stream cipher algorithm (x86-64 version)
Date: Tue, 18 Dec 2007 01:51:27 +0800
Message-ID: <fd3e431c0712170951oe83e5d7i74b2d477de21d7a0@mail.gmail.com>
References: <fd3e431c0712161006mf162962je617794061c19398@mail.gmail.com>
	 <20071216202640.GB29507@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3258_4000696.1197913887489"
To: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:28938 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbXLQRva (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 12:51:30 -0500
Received: by el-out-1112.google.com with SMTP id v27so357139ele.23
        for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 09:51:29 -0800 (PST)
In-Reply-To: <20071216202640.GB29507@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

------=_Part_3258_4000696.1197913887489
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Herbert and Sebastian, thanks for testing the x86-64
implementation. Much appreciated. :-)

I will remember to use "git-format-patch -M" next time. I didn't know
about the -M switch before this.

Sebastian is right about the "select CRYPTO_SALSA20". It seems
unnecessary in both i586 and x86-64 versions. Attached is a patch that
removes them.

Swee Heng

------=_Part_3258_4000696.1197913887489
Content-Type: text/plain;
 name=0001-Removed-dependency-on-CRYPTO_SALSA20.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fabaximr0
Content-Disposition: attachment;
 filename=0001-Removed-dependency-on-CRYPTO_SALSA20.txt

U3ViamVjdDogW1BBVENIXSBSZW1vdmVkIGRlcGVuZGVuY3kgb24gQ1JZUFRPX1NBTFNBMjAKClNp
Z25lZC1vZmYtYnk6IFRhbiBTd2VlIEhlbmcgPHRoZXN3ZWVoZW5nQGdtYWlsLmNvbT4KCi0tLQog
Y3J5cHRvL0tjb25maWcgfCAgICAyIC0tCiAxIGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9jcnlwdG8vS2NvbmZpZyBiL2NyeXB0by9L
Y29uZmlnCmluZGV4IDkzYWQ1M2EuLmMzMTY2YTEgMTAwNjQ0Ci0tLSBhL2NyeXB0by9LY29uZmln
CisrKyBiL2NyeXB0by9LY29uZmlnCkBAIC00OTQsNyArNDk0LDYgQEAgY29uZmlnIENSWVBUT19T
QUxTQTIwXzU4NgogCWRlcGVuZHMgb24gKFg4NiB8fCBVTUxfWDg2KSAmJiAhNjRCSVQKIAlkZXBl
bmRzIG9uIEVYUEVSSU1FTlRBTAogCXNlbGVjdCBDUllQVE9fQkxLQ0lQSEVSCi0Jc2VsZWN0IENS
WVBUT19TQUxTQTIwCiAJaGVscAogCSAgU2Fsc2EyMCBzdHJlYW0gY2lwaGVyIGFsZ29yaXRobS4K
IApAQCAtNTA5LDcgKzUwOCw2IEBAIGNvbmZpZyBDUllQVE9fU0FMU0EyMF9YODZfNjQKIAlkZXBl
bmRzIG9uIChYODYgfHwgVU1MX1g4NikgJiYgNjRCSVQKIAlkZXBlbmRzIG9uIEVYUEVSSU1FTlRB
TAogCXNlbGVjdCBDUllQVE9fQkxLQ0lQSEVSCi0Jc2VsZWN0IENSWVBUT19TQUxTQTIwCiAJaGVs
cAogCSAgU2Fsc2EyMCBzdHJlYW0gY2lwaGVyIGFsZ29yaXRobS4KIAotLSAKMS41LjMuNgoK
------=_Part_3258_4000696.1197913887489--
