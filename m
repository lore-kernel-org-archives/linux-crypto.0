Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951693;
	b=U2cAKBzL37yH6wiSVvpvytFwD+fdrjGl+lCo/kTKhCLVRXDcbZDLy6vr87fyJyB8DfIz
	 UWsAaTtHJWq7u8uWn0EGtInowtDQjaY7iRjpwWTtlHjFQzKSsmEiODmetHFKb9Ssxr5sS
	 X2WSJ7WYUTJxx+/VMgGyjQ8EtRHLRxDp92v4QWl5Gem/6X+g6E4fuuBDTu+uK6zopf2YD
	 hc2NBs3Yx6Jr8x3/JDH8+bLcDCinZD2jv7pVpiG1x+bA1t9JYkSh0/jXedom56K75lZGb
	 TPkVQvyjsz5desqDsHh4lJpJqYNoFU73sd8+IBy+bvAvwRz03dFVbZITSUtLtCaToZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951693;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=I6hs8fDnfJGSViO7aVAvC3h+MaWZ4bGM9QBdrdQkCqQ=;
	b=g+RVPjVLqDRqYM1KXE9FUQnPNQ2vzTfYUW5AX2xkGe+uiVJN6yToPgowVWHi7qqgR1r3
	 hcyHDAbvVi9LnSJY6QJrleKBh18GTuklTLUF3iQFs61/8EfqP9j59B0PfhJNhQbZKNTF8
	 czCKCHBxcbWCJzH1ik+tl8EjZcW+PYw3xqO0ddFdfwNTYfaX2tddAt9hDPYFnFd/oCBrx
	 Z53UpdYwJRjWYputn5ErUJcoa318peWlPPAG2GAf3jw8LOgX2FYNdv5R5eYW1GMdm8Dkn
	 deWWAn4v4Dt7SSWiLbyf7up2hFkkZbgYjk+vfhAUPnv3i1s/4pFRbcyEvUn23RsvE0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jV3WpjJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729BD606A326;
	Fri,  6 Nov 2026 07:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jV3WpjJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740471F0089F;
	Fri,  6 Nov 2026 07:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793951693;
	bh=I6hs8fDnfJGSViO7aVAvC3h+MaWZ4bGM9QBdrdQkCqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jV3WpjJeXtZc41R7xdeQAVPTDKTqclZPVV5aM7spt9cL3NJcaOF63qmQZhrwYFdB4
	 xBrvasbJJixP/du9LH2ALvjTkRpumGF6MTM24KfghOujC2s6iMbQ+SK0qJdldPzRU6
	 rl8w9hX7z+N0GPgjWhC8jalVp0be/s/tie1iQKFTw4729O1l4llIg1yh8myOI8fPah
	 q7NtMpKt1ohDcEh2eVL7EtMarcAAVIGTCF4Gn3LFsL6rH0/XjGcSG7rszVMBZit7FN
	 Z6CVO49GseOWHROzSG2khINvz3ZmVAXCXtID34OzBJpidQMOF8x/RbyVrshMPLYhOC
	 6wTt3+iA5F4FQ==
Message-ID: <e34e5630-2f3e-4f7f-9f47-4fec11c1a61e@kernel.org>
Date: Fri, 6 Nov 2026 08:54:47 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: chelsio - Fix wrcount leak in chcr_aes_decrypt()
To: Herbert Xu <herbert@gondor.apana.org.au>, Wentao Liang <vulab@iscas.ac.cn>
Cc: ayush.sawal@chelsio.com, davem@davemloft.net, harsh@chelsio.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260916092359.2001753-1-vulab@iscas.ac.cn>
 <arNk6ujyrvTsFBfS@gondor.apana.org.au>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <arNk6ujyrvTsFBfS@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/09/2026 07:34, Herbert Xu wrote:
> On Wed, Sep 16, 2026 at 09:23:59AM +0000, Wentao Liang wrote:
>> chcr_aes_decrypt() increments the device inflight count with
>> chcr_inc_wrcount() before building the work request, but it returns
>> early without dropping the count when the tx queue is full or when
>> process_cipher() fails and returns no skb. The count is only dropped
>> by the completion handlers, so every failed request permanently skews
>> the count and eventually blocks the device from being detached, with
>> the detach worker warning "CHCR:request Still Pending".
>>
>> Add an error label that calls chcr_dec_wrcount(), mirroring
>> chcr_aes_encrypt(), and jump to it on the failure paths.
>>
>> Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
>> ---
>>  drivers/crypto/chelsio/chcr_algo.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> Plesae combine this with the encrypt patch and repost.

After further discussions/postings it is likely that vulab@ is not a
real person, but a bot. It is also possible that it hides intentional
bugs among good looking patches, thus please be cautious and thoroughly
review the patch.

Best regards,
Krzysztof
