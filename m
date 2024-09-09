Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A23188006;
	Mon,  9 Sep 2024 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725849911; cv=none; b=PFvqg1ymxPslV1jy/pCBngq78fI6+c8f3QAr4CXe0QrXzHA06QQr8EvM34T54wQ7sVKf1yAWw/Zo/ATyxXbOvaqQy1jvyH8fimgIZO97hU1cvwZQ0iY9nNZjEfehDYUog6iE+nArXEmrJjSTzIUiSfXF2a3ezh9YC52gmebnMJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725849911; c=relaxed/simple;
	bh=9mCASzXL3SkJGAn4yBZBv8+/ZVpK84u2Ggl+M7JU0bM=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To; b=mPhnocU5q6k4T3o1gmTn/8+yVwfECMKc0qXqjsaYspREoJ5VsH+x7PgNqqrZJgCLjnel7ZDIflgnOWjz0SJFS5tde/yNFyjqJWIhpZn/CQzCXfBEt+F4T8Dfd6GapO1m46oWuxx0+b0p+kx7IU0sleb+NtTu2g2S2Bm3bmmYnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8267631c6e5511efa216b1d71e6e1362-20240909
X-QC-Scan-Result: 0
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:c335ac5c-dccb-4942-8ec1-d5bbf26db4e0,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:5,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.1.38,REQID:c335ac5c-dccb-4942-8ec1-d5bbf26db4e0,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:5,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:82c5f88,CLOUDID:96f4b2e2f89e4a356c29e0e4c4946826,BulkI
	D:240909104502NXS94GMF,BulkQuantity:0,Recheck:0,SF:66|23|17|19|43|74|102,T
	C:nil,Content:4|-5,EDM:-3,IP:-2,URL:0,File:2,RT:nil,Bulk:nil,QS:0,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 8267631c6e5511efa216b1d71e6e1362-20240909
X-User: zhaomengmeng@kylinos.cn
Received: from [192.168.109.86] [(123.149.251.227)] by mailgw.kylinos.cn
	(envelope-from <zhaomengmeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 126920555; Mon, 09 Sep 2024 10:45:01 +0800
Content-Type: multipart/mixed; boundary="------------4X4PPaDgek81WNTrv40SqJWp"
Message-ID: <48435cf7-8c2d-4d3e-8b26-f8814f9a6338@kylinos.cn>
Date: Mon, 9 Sep 2024 10:44:51 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+17cae3c0a5b0acdc327d@syzkaller.appspotmail.com
Cc: almaz.alexandrovich@paragon-software.com, davem@davemloft.net,
 haren@us.ibm.com, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
References: <00000000000097e14f0621951335@google.com>
Subject: Re: [syzbot] [crypto?] [ntfs3?] KMSAN: uninit-value in sw842_compress
From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
In-Reply-To: <00000000000097e14f0621951335@google.com>

This is a multi-part message in MIME format.
--------------4X4PPaDgek81WNTrv40SqJWp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test
--------------4X4PPaDgek81WNTrv40SqJWp
Content-Type: text/x-patch; charset=UTF-8; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL250ZnMzL25hbWVpLmMgYi9mcy9udGZzMy9uYW1laS5jCmluZGV4
IGYxNmQzMThjNDM3Mi4uMzliMTJjZjU4YTU0IDEwMDY0NAotLS0gYS9mcy9udGZzMy9uYW1l
aS5jCisrKyBiL2ZzL250ZnMzL25hbWVpLmMKQEAgLTI2LDggKzI2LDEyIEBAIGludCBmaWxs
X25hbWVfZGUoc3RydWN0IG50ZnNfc2JfaW5mbyAqc2JpLCB2b2lkICpidWYsIGNvbnN0IHN0
cnVjdCBxc3RyICpuYW1lLAogCXN0cnVjdCBBVFRSX0ZJTEVfTkFNRSAqZm5hbWUgPSAoc3Ry
dWN0IEFUVFJfRklMRV9OQU1FICopKGUgKyAxKTsKIAogI2lmbmRlZiBDT05GSUdfTlRGUzNf
NjRCSVRfQ0xVU1RFUgotCWUtPnJlZi5oaWdoID0gZm5hbWUtPmhvbWUuaGlnaCA9IDA7CisJ
Zm5hbWUtPmhvbWUuaGlnaCA9IDA7CiAjZW5kaWYKKwllLT5yZWYubG93ID0gMDsKKwllLT5y
ZWYuaGlnaCA9IDA7CisJZS0+cmVmLnNlcSA9IDA7CisKIAlpZiAodW5pKSB7CiAjaWZkZWYg
X19CSUdfRU5ESUFOCiAJCWludCB1bGVuID0gdW5pLT5sZW47Cg==

--------------4X4PPaDgek81WNTrv40SqJWp--
