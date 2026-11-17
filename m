Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921699;
	b=NSwFDPemuJw5Ct0UeNqrd+/CdRiOn8S/hxnK89T4qbRhx7eoZlLlvGF7CrogEnSWqnTS
	 rA+I/xwMd1gY9EaGRgJuObHsZqVASm1qrPh8fOIrF0xP3r9T3u5V6lDcsGO3/KbFbvwaR
	 4l5pd8QaOJlV3IYUbGLJ7WRFY4xuq+HbcddOuH0MOhaV7gPiIAONxxCL5v2gT4MbrzsY7
	 iFusK2/PrlnRFPlwIe4J0tc0bMDKfZM1dCfYJ5Pzing/CYTkDuycA/3vkiFungyxNoZXF
	 NtfFEnKI4Jo3JZivBJlN7jD6J20n//OM9Hy5ZAx/evnul3SSFL+6+YNTBSFb3L0pkdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921699;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=CWKy/Xe5D3WLDxIMxxMZifmNFWiFuSMPKw85DviN7N8=;
	b=dp8iL/uhh3alDPYgxyD6phlpQf0Sxyhxb7gPJKSgysMTHL6WdwHCgiA5eg1O5D31K+Cp
	 drphAY9k1fLySII0nHgruFdwKn1mjzn1ynWdXwjv/8N7kwOzeN90ow4m7FxWh8Wq5mTxb
	 TRpkVUtL4mqkpLquSGNalfdCi8Q/d8cnXR2x4wa1LFoZrqsXIoJJDrS8X4zOxxuYXwNJH
	 AuJIV0/cey+RP/Lkq6fLXnmWFJCJ0XPG1fvAlnsKttbga+SpV/C2BYW0efR+QRDVxOrgY
	 68s+i0etbjS1a7ADxq/rlYd890DADalPtALIfFgpUADzHkOKbfQX1YIBCmKKZDjAcxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=D3LHUF9a;
	arc=none smtp.remote-ip=62.149.156.72
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC6606A329
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 13:21:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEDC6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=D3LHUF9a
Received: from [192.168.0.186] ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TJ7nx1DnacPcsTJ7nxe0qW; Tue, 17 Nov 2026 14:21:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1794921689; bh=oT2PXSW88ArmQaqNSfEwrssUL0dmXrSRZQiuFx9AOd0=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=D3LHUF9aQVXKQ9UYUAuA7NcPsl7BxfeUkL4oPBUdEqZXYDqb3z7e6J1CpDrKNvAaW
	 FjXwqAeTCHmUYrrMsoTo9ECEVQSofvqgnLkdS16Huf5+yxZ36R6EkrMC1lwJPKt/dP
	 W5Yv3mmn4/UEChNu7vuU6HPWQ7WotSwx9EBRzr/ilp803lg6O9lBrSeJc4kTtuW5T9
	 JMRv6rH/v/F9jevkqU6/KbzUxwECPrTwg3y4tU/Oqod3O6X4vdWq+sdE+zr+7lJ63R
	 smxM4IyZIlcdPa4oVOV/2RZkjbTo4owA78Gutm179EV2aTRPTlI117fu7Jmbr/WRft
	 V6RJOdFZJ80bA==
Message-ID: <0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com>
Date: Tue, 17 Nov 2026 14:21:26 +0100
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
Subject: Re: [PATCH 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Content-Language: en-US
To: Florian Bauckholt <florian.bauckholt@cispa.de>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
 Stefan Berger <stefanb@linux.ibm.com>, keyrings@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDg+biMxW//ioyRGFd9IFIlidEW1a2KiKD2evhiscr/Ncy3LgypJUgynMd+o8RcM6m0eFTTCJ1Y8aXl826d0s2qqGHBPJuRg8drh+k/ewjJ5c2Ng73LR
 N1Sj2F7NHEHNenpSVYzQjg322kfqmTdrNt6CuKC306/WtrTJ4wHiazfLjV8+mQgXARt9KWCyR8mz5Q2XRks657UfSiRgqNd1ZYLcQs9OlasaNk6dGFhFFmoc
 Z2FUAQk5bG+wrDzFA+GhruflgGh4nb6+rZh82j3ZE2lkIL8s4ax2X0j+qB2EBx5WDzCUIs7cD//QfBopsXqJhBSSY3asWR4psvoAO2V5DCHwWR+8fqzwZVQ3
 zWxAZXS6nvWdCV8z6ZLxLGXwOheVDOkyjoT0+v3JinadqrBrK6t/n0Okxk/VuHAFPtIkkfgYq6Vy4j1IGNdU24E9idR72uM67iouzpuPw9J6Jja6IaR1wbL+
 jAB4i0/IEubK9G0Zzhd8ALVt+hyPUT9Av/tFfSpZWWpWweuUW5FLEiP95GfseydpODLCfV771PTvl/oMXt1dYSIj2lWGReGq2vVbifJoiSfW5HnLMG2dyhXC
 jiMSlAznQPDMk5GEpsO0TNidxiRm6MzTbXqm5/7lWUZAXsLBql/Qex9lAVI7JZpTq7q4veUjqLK1gtQYpyUcvHc47fqhA5ay/gp+aB5BS/wfb4HHJJChllbv
 HUgKPjrfCjq0IoHhg1AENiug5UQqKvMh

On 11/11/2026 16:56, Florian Bauckholt wrote:
> Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> made keyctl_pkey_params_get_2() set params->out_len to the maximum
> output size of the operation instead of the size provided by the caller.
> It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> buffer: out_len shares a union with in2_len, the length of the
> signature.
> 
> As a result keyctl_pkey_verify() ignores the signature length passed by
> the caller. It copies max_sig_size bytes from the signature pointer and
> passes max_sig_size as the signature size to the verification.
> 
> This makes no difference for signatures that are always max_sig_size
> bytes long, such as RSA. A shorter signature, e.g. a DER-encoded ECDSA
> signature, is followed by whatever is behind it in the caller's memory,
> or the call fails with -EFAULT if that memory is not readable. The
> x962 ECDSA template currently ignores data following the signature,
> which hides the problem.

The test suite of craf (https://github.com/giometti/crypto-afalg,
test3008) hits this with RSA too: it cuts a genuine 256-byte RSA-2048
PKCS#1 signature to 255 bytes and expects the verify to fail. On
Ubuntu's 6.8.0-147 kernel, which carries the stable backport of
cb481e59ea6c, the cut signature verifies about once in 256 runs. Over
2000 runs per build:

    plain: ok=1991 ko=9
    asan: ok=1997 ko=3

and a failing run prints (line wrapped here):

    libkcrypto  [pkey-cert]: kc-check pkey-verify cert:test3008.cert
        enc=pkcs1 hash=sha256 test3008.d256 test3008.bad: exit 0, not 1:
    KO!

To reproduce it (the count printed is the number of failures; here it
gave 3 out of 1000 runs):

    git clone https://github.com/giometti/crypto-afalg
    cd crypto-afalg/tests
    export TESTS_TMPDIR=$(mktemp -d)
    for i in $(seq 1000); do ./do_test.sh 3008; done | grep -c 'KO!'

I also replayed the inputs of one failing run on a UML kernel of
current mainline (666539eecdf4, after v7.4-rc3): the 255-byte signature
verifies 20 times out of 20, and with your patch applied it is refused
20 times out of 20.

Maybe it is worth saying so in the commit message, since this is going
to stable?

I'll send my Tested-by once test3008 has run 2000 times on a kernel
with your patch applied.

> 
> Use the length provided by the caller, which has already been checked
> against max_sig_size.
> 
> Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> ---
>  security/keys/keyctl_pkey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> index 15b6bf6399b5..794fa3d01911 100644
> --- a/security/keys/keyctl_pkey.c
> +++ b/security/keys/keyctl_pkey.c
> @@ -160,7 +160,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>  		    uparams.in2_len > info.max_sig_size)
>  			return -EINVAL;
>  
> -		params->out_len = info.max_sig_size;
> +		params->in2_len = uparams.in2_len;
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
>

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
