From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 1/2] tcrypt: Added salsa20-generic speed test
Date: Thu, 6 Dec 2007 03:11:35 +0800
Message-ID: <fd3e431c0712051111j5f142292u831f803a53612d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_474_33523779.1196881895946"
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:26677 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLETLj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Dec 2007 14:11:39 -0500
Received: by ug-out-1314.google.com with SMTP id z38so536807ugc
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2007 11:11:37 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

------=_Part_474_33523779.1196881895946
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch adds a simple speed test for salsa20-generic.
Usage: modprobe tcrypt mode=206

Signed-of-by: Tan Swee Heng <thesweeheng@gmail.com>

------=_Part_474_33523779.1196881895946
Content-Type: text/plain; name=patch1-salsa20_speed.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9u8ji9y0
Content-Disposition: attachment; filename=patch1-salsa20_speed.txt

ZGlmZiAtLWdpdCBhL2NyeXB0by90Y3J5cHQuYyBiL2NyeXB0by90Y3J5cHQuYwppbmRleCAzODdk
MTA1Li42YTQ3NGY0IDEwMDY0NAotLS0gYS9jcnlwdG8vdGNyeXB0LmMKKysrIGIvY3J5cHRvL3Rj
cnlwdC5jCkBAIC0xNjU5LDYgKzE2NTksMTEgQEAgc3RhdGljIHZvaWQgZG9fdGVzdCh2b2lkKQog
CQkJCWNhbWVsbGlhX3NwZWVkX3RlbXBsYXRlKTsKIAkJYnJlYWs7CiAKKwljYXNlIDIwNjoKKwkJ
dGVzdF9jaXBoZXJfc3BlZWQoInNhbHNhMjAtZ2VuZXJpYyIsIEVOQ1JZUFQsIHNlYywgTlVMTCwg
MCwKKwkJCQlzYWxzYTIwX3NwZWVkX3RlbXBsYXRlKTsKKwkJYnJlYWs7CisKIAljYXNlIDMwMDoK
IAkJLyogZmFsbCB0aHJvdWdoICovCiAKZGlmZiAtLWdpdCBhL2NyeXB0by90Y3J5cHQuaCBiL2Ny
eXB0by90Y3J5cHQuaAppbmRleCA1N2Y1NGM3Li5iOWRjNDE0IDEwMDY0NAotLS0gYS9jcnlwdG8v
dGNyeXB0LmgKKysrIGIvY3J5cHRvL3RjcnlwdC5oCkBAIC03ODgxLDQgKzc4ODEsMjAgQEAgc3Rh
dGljIHN0cnVjdCBjaXBoZXJfc3BlZWQgY2FtZWxsaWFfc3BlZWRfdGVtcGxhdGVbXSA9IHsKICAg
ICAgIHsgIC5rbGVuID0gMCwgLmJsZW4gPSAwLCB9CiB9OwogCitzdGF0aWMgc3RydWN0IGNpcGhl
cl9zcGVlZCBzYWxzYTIwX3NwZWVkX3RlbXBsYXRlW10gPSB7CisgICAgICB7IC5rbGVuID0gMTYs
IC5ibGVuID0gMTYsIH0sCisgICAgICB7IC5rbGVuID0gMTYsIC5ibGVuID0gNjQsIH0sCisgICAg
ICB7IC5rbGVuID0gMTYsIC5ibGVuID0gMjU2LCB9LAorICAgICAgeyAua2xlbiA9IDE2LCAuYmxl
biA9IDEwMjQsIH0sCisgICAgICB7IC5rbGVuID0gMTYsIC5ibGVuID0gODE5MiwgfSwKKyAgICAg
IHsgLmtsZW4gPSAzMiwgLmJsZW4gPSAxNiwgfSwKKyAgICAgIHsgLmtsZW4gPSAzMiwgLmJsZW4g
PSA2NCwgfSwKKyAgICAgIHsgLmtsZW4gPSAzMiwgLmJsZW4gPSAyNTYsIH0sCisgICAgICB7IC5r
bGVuID0gMzIsIC5ibGVuID0gMTAyNCwgfSwKKyAgICAgIHsgLmtsZW4gPSAzMiwgLmJsZW4gPSA4
MTkyLCB9LAorCisgICAgICAvKiBFbmQgbWFya2VyICovCisgICAgICB7ICAua2xlbiA9IDAsIC5i
bGVuID0gMCwgfQorfTsKKwogI2VuZGlmCS8qIF9DUllQVE9fVENSWVBUX0ggKi8K
------=_Part_474_33523779.1196881895946--
