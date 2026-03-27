Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C0372B37
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631039; cv=none; b=XU2D9G86POL02Ws3aOpiGOUorc1a0mIvsjdgcrGPE3dxRrEH/8xfRis18ASO5M0KWZeVFDZS+Y4LThcB4LPLDOEfm9ggTlhFGW9LAkkuZ5dDvfZPLdSYPY3W6zPAXvCvK39v7yeoILK+d/oa3ITYcxBf/wb7zSJ1WsDkdeDkFnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631039; c=relaxed/simple;
	bh=+tauNC4op/1f1UOR6hc+/glfE3S89C+fm7BIK2HXnBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WpSMknzREl34XvCYCEQ1Sautd2dXYXejGfwN3OVDotwVM1XUlZd3dsVUBVnmf0dXRgwzPp0LKJN4ZGTymsRYcN3wfgx904e39gRWaQGh9va70srCKxHlTYHJMj2oRUVVjZrRWIy4UZVD3H7kglO59222gP2pu535OuMJn47q0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=CUSlZjbC; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="CUSlZjbC"
Received: (wp-smtpd smtp.wp.pl 22480 invoked from network); 27 Mar 2026 18:03:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774631028; bh=1pNHOOxkrInwAKVW1kychxWbDV24cN7qwurpLcenHAg=;
          h=Subject:To:Cc:From;
          b=CUSlZjbCPiBqxQiLpBHw2huIXCvZEblim9cHHLDW+olL1wSW0EUM03fCaDQlC6vhk
           seIVRHg+yHBBx2eMqOJ6c7+Pch2dzdgrBTC9ocHOIbZKhlSuPDgCnZSZL4NvF+PFi/
           fjvpWRR2REI1HKvnOMYMINOEr+SGCX8kfdpV1qk+pdXpgjXu4Fh61Ucaiag14ywOWD
           Brxok7210QSDFuM/h4YlftujO9V3uT+07kKpAk9bkgp2YlV/C8qMLe/djDe8NJ5r4U
           wL0UqmcrxEIc5BXmYe/rgGZBWanSraSi+HnYQz4f+sI0rajVL1vLDEWZ19OE6UK1xx
           XE4xilcro5gzA==
Received: from 83.5.169.164.ipv4.supernova.orange.pl (HELO [192.168.1.21]) (olek2@wp.pl@[83.5.169.164])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 27 Mar 2026 18:03:48 +0100
Message-ID: <c2a3dc2e-8d4a-4a59-ac5a-ca22be705488@wp.pl>
Date: Fri, 27 Mar 2026 18:03:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(aes))
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
 alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260303184916.69132-1-olek2@wp.pl>
 <abToanZh-mkEjmJ-@gondor.apana.org.au>
Content-Language: pl
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <abToanZh-mkEjmJ-@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: c35bd8ae87df3f160010f467442666b9
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [YFOn]                               

Hi Herbert,

On 14/03/2026 05:47, Herbert Xu wrote:
> On Tue, Mar 03, 2026 at 07:48:44PM +0100, Aleksander Jan Bajkowski wrote:
>> Test vectors were generated starting from existing CBC(AES) test vectors
>> (RFC3602, NIST SP800-38A) and adding HMAC(MD5) computed with Python
>> script. Then, the results were double-checked on Mediatek MT7981 (safexcel)
>> and NXP P2020 (talitos). Both platforms pass self-tests.
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>> v4:
>> - rename aes-generic -> aes-lib
>> v3:
>> - correct sha384 -> md5 in description
>> v2:
>> - rebase and resolve conflicts
>> ---
>>   crypto/testmgr.c |   7 ++
>>   crypto/testmgr.h | 255 +++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 262 insertions(+)
> The previous patch has already been applied.  Please redo this
> as an incremental patch.

Checked the crypto tree, and this patch still isn't applied. I've sent 
multiple test vectors, and you're probably referring to a another patch. 
Should I send it again, or will you accept it as is?

By the way, that's the last one. As of now, all my routers have the 
missing vectors added :)

Regards, Aleksander

