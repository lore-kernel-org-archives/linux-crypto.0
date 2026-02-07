Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DDE1DE3DB
	for <linux-crypto@vger.kernel.org>; Sat,  7 Feb 2026 14:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770474702; cv=none; b=AU9IMyhXXVwsfDivlGbFNYmZCtVX0t2f2a4yf/iiz85mOysL68z22Yi5xb/rMcFFOVIQ073GRuW527BXvLPdMQxscVacBGIK3nkrj1xXtK38IN+OLXotWF9k6umYRcbMh4py3JzoJt3Mpr9XwAMQS02IV+VbJiiaS8eHomMAFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770474702; c=relaxed/simple;
	bh=iaWQ66t2xNW9DRb6yq/FYL1V91XIFMQWUsOiCt2GxlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyRXscVNNzQqc9nFEkzjRgOUldGt9td3/2ORQh4QZTVTnCVvXLVYPCS1boDvK31pMS53PFD5Vn2yZdGgY2v3K7ew3ln8mOJ4icQ6m0NxlB0J5OUqAycuKtaQDaVdTdnZHxdPxRbiD2c7f2h2fPsGGkfQY+u+H7dwBDEuu4V2UEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=Pb8CnKdl; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="Pb8CnKdl"
Received: (wp-smtpd smtp.wp.pl 11881 invoked from network); 7 Feb 2026 15:31:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770474698; bh=tKfz8khjNl/LTu3C6GNZbX7HdCtyRoxHHXHrzIGrMME=;
          h=Subject:To:Cc:From;
          b=Pb8CnKdlS/CPgQk4qAreqcA8wUwE4yRtmJNyM5nfU3l8ZQU/FbcS8iIlIrwEjUph+
           9RI3eP7L9OzuTfVrH3EO0YWhF8BoVRJBgpX153dlhAFHyPeI7F1+kGmuss0Lp4PJDS
           YD/CwaZgd4abkL76lfvLSs2kfMfg4qoNbt+aP+oNP2v7yGyBlSnL2nvvBEeik7ysz3
           6ilI2k6fJMVwA16jgmYHZM3vKmZfEi+2gEU1BS30/ZheroWEtnAC+DOJbzuWRNrhV9
           ZnEWNo4QhE/WemtCQzlp66k36rnUqU5vHRnqWHnPIzWr62WPealH8ihnGw+EacDobZ
           T4IxAXGauDg4Q==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 7 Feb 2026 15:31:38 +0100
Message-ID: <4be44ce1-6e46-4fc7-9497-7a99f8e54047@wp.pl>
Date: Sat, 7 Feb 2026 15:31:37 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(des3_ede))
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260201112834.3378-1-olek2@wp.pl>
 <aYXKFtmVJCCZpUVw@gondor.apana.org.au>
 <3622af67-b083-488a-998a-29b8657be73a@wp.pl>
 <aYaWWy2KSYz787a-@gondor.apana.org.au>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <aYaWWy2KSYz787a-@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-WP-MailID: affa130d7d053aabd69a05928304064c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [gJP0]                               


On 2/7/26 02:33, Herbert Xu wrote:
> On Fri, Feb 06, 2026 at 08:40:18PM +0100, Aleksander Jan Bajkowski wrote:
>> While resolving the conflict, the entry was added in the wrong place. As a
>> result, the test manager complains about sorting:
>> [    0.050891] testmgr: alg_test_descs entries in wrong order:
>> 'authenc(hmac(md5),ecb(cipher_null))' before
>> 'authenc(hmac(md5),cbc(des3_ede))'
> Thanks for the heads up.  I've just pushed out a fix, can you
> please double-check?
It's fine now. Thanks.


>
> Cheers,
