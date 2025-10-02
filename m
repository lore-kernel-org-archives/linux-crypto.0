Received: from mail132-2.atl131.mandrillapp.com (mail132-2.atl131.mandrillapp.com [198.2.132.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2857027CB02
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.132.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759428257; cv=none; b=fP+en47hKSSVH2QqNHEiicdHVjPjj4rS0Sv0G7F1wiYOQgV/Q0qh0xwG7raL5tKkpbGkxJXLjgN42XizbIq0QewctIss1ze2owaK5q9W7VSQcyMZprwr8XxwrS4Avp438dAlsrmu7J5/+Cg3VeuIKSIQmZnR8T7VGchgRsrLekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759428257; c=relaxed/simple;
	bh=aXEIbACNRtnofIP0VZq3wF1u+oABNhMX4NkKLUF3g2Y=;
	h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type; b=elJTJBldhLAF4/BHFT+FsDPPjclw5q0Kj7cLCrsohBn9s/0sZSatxkFBPw/MJoXggTClegm3RUkOeecBMzfcTx05Cpw7Wqlgi2kaPH3+gxi3AFpYGm60yqULIGkABL28YhMofYVioLhldhALc/bBngbZs9VU5LUXFTUUZCYfNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=MKEjX3T3; dkim=pass (2048-bit key) header.d=vates.tech header.i=teddy.astie@vates.tech header.b=vBk+ai2w; arc=none smtp.client-ip=198.2.132.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="MKEjX3T3";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=teddy.astie@vates.tech header.b="vBk+ai2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1759428255; x=1759698255;
	bh=4bpvfICFTTCbiWIKY9SvhS9+6AYpp3DjTixjEpmMXbI=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=MKEjX3T3S3BDLNWeRIQQiTfvuPrpitvjTUlvkEwhm3RLUsaDHdPbgTeO8cVLTbVfo
	 NdW2jt+FgtlchG2a34dFizchoB5MgWuJurKK9TJnh9d69VmOXvUwJfXvaR3/MFbPpD
	 xJYNIjebA3+bwAHhaw3Pif+v6mEe2BnW11wjKxjKQg/DRKrwTOVB4UYdBc/gD2nisg
	 vSHhPq8ehRnkk16l4KAcb7yvmyCKWgvZ8dwbY+M0/SE9Jv9qhM0pxk+vngDhzNLWAS
	 FS8FuQdAp1tcLJ4DV8oCrkt8JKlXcaVMbrxyWtD88zRnu/kmIvnNuLjmbAU6e63MI+
	 7TUagsYyuUtsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1759428255; x=1759688755; i=teddy.astie@vates.tech;
	bh=4bpvfICFTTCbiWIKY9SvhS9+6AYpp3DjTixjEpmMXbI=;
	h=From:Subject:To:Cc:Message-Id:Feedback-ID:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:CC:Date:Subject:From;
	b=vBk+ai2wFw7tRDuAhcFpXFrneoUHUyUghv2N1viCw8APN6KgUl469xrNSMLz4u3DE
	 V4LZQOrtXN/mudcMXttHk5PHGC00lq66Dj2ja57jWOO4FfmRiTx1ZQAa5E+BKiA/y3
	 Zvs2kJxJOoY559S4uPZ6qUC6CEKOqKiJQrsN834s0sMON/27xTuh0yZAy31e9bzBdp
	 zrryl1TTvSBiCexwCoVp7CoETwPayD7Edx/tjG9WAh+MnoMfkuE5dcsnu/R2K+HaVZ
	 PEBinZqH+utY58jffuqo844QDwUDuiXGp9flOhQt/jngrd2wTfKWsAeweO5k3g4pWu
	 v53ITXOijjT2w==
Received: from pmta09.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail132-2.atl131.mandrillapp.com (Mailchimp) with ESMTP id 4cd06l0ZM7zS62WRd
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 18:04:15 +0000 (GMT)
From: "Teddy Astie" <teddy.astie@vates.tech>
Subject: =?utf-8?Q?[PATCH]=20ccp/hsti:=20Fix=20bogus=20sizeof=20in=20psp=5Fpopulate=5Fhsti?=
Received: from [37.26.189.201] by mandrillapp.com id bbc73d7870d844dca33b232f15a05bcd; Thu, 02 Oct 2025 18:04:15 +0000
X-Mailer: git-send-email 2.51.0
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1759428253425
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: "Teddy Astie" <teddy.astie@vates.tech>, "Mario Limonciello" <mario.limonciello@amd.com>, "Tom Lendacky" <thomas.lendacky@amd.com>, "John Allen" <john.allen@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Message-Id: <5743ec02c374ce52d1b406d41e9e240d049ee7e2.1759427927.git.teddy.astie@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.bbc73d7870d844dca33b232f15a05bcd?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251002:md
Date: Thu, 02 Oct 2025 18:04:15 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Payload is actually struct hsti_request and not a pointer which
makes the considered payload size smaller than it should be.

Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 82f9327f774c ("crypto: ccp - Add support for getting security attributes on some older systems")
---
CC: Mario Limonciello <mario.limonciello@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/ccp/hsti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c0..0e6b73b55dbf 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
 	if (!req)
 		return -ENOMEM;
 
-	req->header.payload_size = sizeof(req);
+	req->header.payload_size = sizeof(*req);
 
 	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
 	if (ret)
-- 
2.51.0



--
 | Vates

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech

