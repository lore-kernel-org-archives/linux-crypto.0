Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4E17C081;
	Mon,  8 Jul 2024 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720434532; cv=none; b=gTL0HlLqjb6GGePhB4sBOJ/XB7aIx70pKbbkDodlRIX6BGkbwq1XiIBk130NT3Lek5ne5QnIdnbP4vS8fy0EfwH75E2mRQgbKOo0zEIK6tNGbbuviP7tCodnd1LRt2wac7Lw905TO7Kf5gGlWtfReIm2ACiFG7MzKc5nlYl97hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720434532; c=relaxed/simple;
	bh=2r3DNPEzj/wQbKvfTrp1wPLKF/BAwlKvXqtPxJ1qJ9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJ08LYS6hgoD6VWGsgCSyo413R8j7Pr3alFwMCAfRyHnrkw1lmKbPBOSozXMdElE1NVFw1kA7LVlEFG7FfjGQGLrNviuTwwBLp8l5TdERvNhgndtbTGrKwHVr1Nw9A7VchsCygsmYFQKeF+5CBpXDKFrfRApQdUUsuEWRm8fCnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=SVj1RND2; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="SVj1RND2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1720434515; x=1721039315; i=deller@gmx.de;
	bh=I1gYTLcVw0gXZoZ9Ilgn+lc2dfK4AhJQ9D7jZiy+2Jg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SVj1RND2SP8elBLOFlsPkgO572y+VlT+27KzhU856rgYT2hFOazng8OUv4ldeZIS
	 YCAxxhRFIW4/ISE2s1iJ1waUFrI2FJsjHne/zGliivLXCztj3cLxu02F1dRMlTWXG
	 hkPhOWNvz8eDJivW+muyWGrBv0cd2u/VfJPjk1d7YQk83RTQNHJMrqqiK1xHoMqIU
	 372Lzo3yK6K15MaJu3bodspq0REgoUcRFzLNRAWql+Su30ZTfi++JR2o4Rk747gF0
	 kMzds5rkn4rNq5pD+j8u8h/iX6IjM55eqcU9C1PMBkV+OaYb6DGFQ+JUC1FzMKPxA
	 DxRBW9BMTa2pitwzkg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.63.33]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M5fMe-1sSOAT2hQo-008rOP; Mon, 08
 Jul 2024 12:28:35 +0200
Message-ID: <e5bac456-1760-48ff-9759-382ef7f3f392@gmx.de>
Date: Mon, 8 Jul 2024 12:28:33 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: xor - fix template benchmarking
To: Herbert Xu <herbert@gondor.apana.org.au>, Helge Deller <deller@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZnMWDdKJHfYQLDzS@p100> <ZoiKD2A4pJhaEWpW@gondor.apana.org.au>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 xsFNBF3Ia3MBEAD3nmWzMgQByYAWnb9cNqspnkb2GLVKzhoH2QD4eRpyDLA/3smlClbeKkWT
 HLnjgkbPFDmcmCz5V0Wv1mKYRClAHPCIBIJgyICqqUZo2qGmKstUx3pFAiztlXBANpRECgwJ
 r+8w6mkccOM9GhoPU0vMaD/UVJcJQzvrxVHO8EHS36aUkjKd6cOpdVbCt3qx8cEhCmaFEO6u
 CL+k5AZQoABbFQEBocZE1/lSYzaHkcHrjn4cQjc3CffXnUVYwlo8EYOtAHgMDC39s9a7S90L
 69l6G73lYBD/Br5lnDPlG6dKfGFZZpQ1h8/x+Qz366Ojfq9MuuRJg7ZQpe6foiOtqwKym/zV
 dVvSdOOc5sHSpfwu5+BVAAyBd6hw4NddlAQUjHSRs3zJ9OfrEx2d3mIfXZ7+pMhZ7qX0Axlq
 Lq+B5cfLpzkPAgKn11tfXFxP+hcPHIts0bnDz4EEp+HraW+oRCH2m57Y9zhcJTOJaLw4YpTY
 GRUlF076vZ2Hz/xMEvIJddRGId7UXZgH9a32NDf+BUjWEZvFt1wFSW1r7zb7oGCwZMy2LI/G
 aHQv/N0NeFMd28z+deyxd0k1CGefHJuJcOJDVtcE1rGQ43aDhWSpXvXKDj42vFD2We6uIo9D
 1VNre2+uAxFzqqf026H6cH8hin9Vnx7p3uq3Dka/Y/qmRFnKVQARAQABzRxIZWxnZSBEZWxs
 ZXIgPGRlbGxlckBnbXguZGU+wsGRBBMBCAA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheA
 FiEERUSCKCzZENvvPSX4Pl89BKeiRgMFAl3J1zsCGQEACgkQPl89BKeiRgNK7xAAg6kJTPje
 uBm9PJTUxXaoaLJFXbYdSPfXhqX/BI9Xi2VzhwC2nSmizdFbeobQBTtRIz5LPhjk95t11q0s
 uP5htzNISPpwxiYZGKrNnXfcPlziI2bUtlz4ke34cLK6MIl1kbS0/kJBxhiXyvyTWk2JmkMi
 REjR84lCMAoJd1OM9XGFOg94BT5aLlEKFcld9qj7B4UFpma8RbRUpUWdo0omAEgrnhaKJwV8
 qt0ULaF/kyP5qbI8iA2PAvIjq73dA4LNKdMFPG7Rw8yITQ1Vi0DlDgDT2RLvKxEQC0o3C6O4
 iQq7qamsThLK0JSDRdLDnq6Phv+Yahd7sDMYuk3gIdoyczRkXzncWAYq7XTWl7nZYBVXG1D8
 gkdclsnHzEKpTQIzn/rGyZshsjL4pxVUIpw/vdfx8oNRLKj7iduf11g2kFP71e9v2PP94ik3
 Xi9oszP+fP770J0B8QM8w745BrcQm41SsILjArK+5mMHrYhM4ZFN7aipK3UXDNs3vjN+t0zi
 qErzlrxXtsX4J6nqjs/mF9frVkpv7OTAzj7pjFHv0Bu8pRm4AyW6Y5/H6jOup6nkJdP/AFDu
 5ImdlA0jhr3iLk9s9WnjBUHyMYu+HD7qR3yhX6uWxg2oB2FWVMRLXbPEt2hRGq09rVQS7DBy
 dbZgPwou7pD8MTfQhGmDJFKm2jvOwU0EXchrcwEQAOsDQjdtPeaRt8EP2pc8tG+g9eiiX9Sh
 rX87SLSeKF6uHpEJ3VbhafIU6A7hy7RcIJnQz0hEUdXjH774B8YD3JKnAtfAyuIU2/rOGa/v
 UN4BY6U6TVIOv9piVQByBthGQh4YHhePSKtPzK9Pv/6rd8H3IWnJK/dXiUDQllkedrENXrZp
 eLUjhyp94ooo9XqRl44YqlsrSUh+BzW7wqwfmu26UjmAzIZYVCPCq5IjD96QrhLf6naY6En3
 ++tqCAWPkqKvWfRdXPOz4GK08uhcBp3jZHTVkcbo5qahVpv8Y8mzOvSIAxnIjb+cklVxjyY9
 dVlrhfKiK5L+zA2fWUreVBqLs1SjfHm5OGuQ2qqzVcMYJGH/uisJn22VXB1c48yYyGv2HUN5
 lC1JHQUV9734I5cczA2Gfo27nTHy3zANj4hy+s/q1adzvn7hMokU7OehwKrNXafFfwWVK3OG
 1dSjWtgIv5KJi1XZk5TV6JlPZSqj4D8pUwIx3KSp0cD7xTEZATRfc47Yc+cyKcXG034tNEAc
 xZNTR1kMi9njdxc1wzM9T6pspTtA0vuD3ee94Dg+nDrH1As24uwfFLguiILPzpl0kLaPYYgB
 wumlL2nGcB6RVRRFMiAS5uOTEk+sJ/tRiQwO3K8vmaECaNJRfJC7weH+jww1Dzo0f1TP6rUa
 fTBRABEBAAHCwXYEGAEIACAWIQRFRIIoLNkQ2+89Jfg+Xz0Ep6JGAwUCXchrcwIbDAAKCRA+
 Xz0Ep6JGAxtdEAC54NQMBwjUNqBNCMsh6WrwQwbg9tkJw718QHPw43gKFSxFIYzdBzD/YMPH
 l+2fFiefvmI4uNDjlyCITGSM+T6b8cA7YAKvZhzJyJSS7pRzsIKGjhk7zADL1+PJei9p9idy
 RbmFKo0dAL+ac0t/EZULHGPuIiavWLgwYLVoUEBwz86ZtEtVmDmEsj8ryWw75ZIarNDhV74s
 BdM2ffUJk3+vWe25BPcJiaZkTuFt+xt2CdbvpZv3IPrEkp9GAKof2hHdFCRKMtgxBo8Kao6p
 Ws/Vv68FusAi94ySuZT3fp1xGWWf5+1jX4ylC//w0Rj85QihTpA2MylORUNFvH0MRJx4mlFk
 XN6G+5jIIJhG46LUucQ28+VyEDNcGL3tarnkw8ngEhAbnvMJ2RTx8vGh7PssKaGzAUmNNZiG
 MB4mPKqvDZ02j1wp7vthQcOEg08z1+XHXb8ZZKST7yTVa5P89JymGE8CBGdQaAXnqYK3/yWf
 FwRDcGV6nxanxZGKEkSHHOm8jHwvQWvPP73pvuPBEPtKGLzbgd7OOcGZWtq2hNC6cRtsRdDx
 4TAGMCz4j238m+2mdbdhRh3iBnWT5yPFfnv/2IjFAk+sdix1Mrr+LIDF++kiekeq0yUpDdc4
 ExBy2xf6dd+tuFFBp3/VDN4U0UfG4QJ2fg19zE5Z8dS4jGIbLg==
In-Reply-To: <ZoiKD2A4pJhaEWpW@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4gnEIKZwOc7F1KNOy6SDMVuSLkGFl5k4O8hHqW5PizzyGufM9BK
 5ytvx0m86b1fUTkmckyfKX1/j6P/qGk8k2HUhTSo7f0qQcZSyvwT25SbkB2uJ6EvqDUyrGZ
 gPdPVHzbWV8TWiBsyvSCyiUSHGgGVC/gjD712t5hW33+zuEKzF7USPQFGgCl7FpWUO47Rvk
 2AqGnU06vS7K9WHqr7qag==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZcU8CC2TWnU=;PInqwIhf/Yd+DiyY0edES811vxi
 UxwnsTT7Qkdrh8mZTrnrSIqV8iEnr+58wsDPV12DA59QPftU6H0ew0tDLDVnu0V4OwX9rUfTf
 QHlPUPrqveURJ0PSIkujKUpzf0w3lPwJouTscXDevvMX815I82lxQIVCLOWzOtj02to9Uldas
 KTS0AzIZS9tpnAcF3Kz1DlI+mASJe99Xc//K+3mURgMOBizc/nXH1sUcHm6eqis7kOoWcyxAl
 r4LLPlLS0DGqDX8f36p9TVMjaN+EDg6fHVBZHbnrdxQ2vpr/jT/QVtqjKc0K8SRz3cly9Ij1F
 Yjr1xH4iC2k9F1uclk8fASBU4sUvg6Iol/llxQfb87Bp1YVrr/In3mEG79DAY327S7i0HyJCo
 jiyE7xSLj9FMW8kze+rFnvk+w/l/jRjruCHukkB3InVzosWKTboDqfSLcv4qkIi2G8X3VOAqR
 nvMNfUtdC9U4vst2ZxGozDE5G6j128qNn9/ZigO5zGg8UBhC/JHTcWVpq1PWLHi+X1knlYRxP
 LOdZL+IE26qWm52U0ipvpoWmGy0K1UI8Ob88NPaXu2vZSsws5FtIzmWbT5cRmX/sU8M9MkaAX
 H9BkLoUGixjB1B25ijtG+IxDyvx5ApN0gvLe/XPTvb1CA0HNAfk1j9KKEDU1r0Qr44kgyV/xq
 gPw7bhKqrnaRaIO7DMBYh2qVwQ2yX9kIPl5xBZ7few084nCUaPlyf9WmBjNQJySLvaeA6P4tt
 TxblKZlFpohbKqLIZyaHBtadI0qiCIeaA/idWwtbJtxTwMauAgaEHFJqUz+CwDQ+HDRA6Kx9S
 IJvpx2Hg7AMevM/VDMoU5Xg5+3xlqPPGhZWO5nJNv/EaY=

On 7/6/24 02:04, Herbert Xu wrote:
> On Wed, Jun 19, 2024 at 07:31:57PM +0200, Helge Deller wrote:
>>
>> +	t0 =3D ktime_get();
>> +	/* delay start until time has advanced */
>> +	do { start =3D ktime_get(); } while (start =3D=3D t0);
>
> Please rewrite this loop in the usual kernel coding style.

Ok.

> What about adding a cpu_relax() in there if ktime_get doesn't
> advance? Something like
>
> 	while ((start =3D ktime_get()) =3D=3D t0)
> 		cpu_relax();

Yes, looks better.
Will send updated patch.

Helge
