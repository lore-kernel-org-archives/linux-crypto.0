Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795083911;
	b=UVzMLs0zOgD2rQ8+9GIGM5kfdp+sRQWa7LVeK3TgqiQz4GwI+9mawH9ezrp8vYNmIskQ
	 juISsEAjel7e8seaWr4IyVbr2CrQYwIBxyYW18QvAhBhmCfmc6NHrK3rnIEeSXPHZFG2H
	 nv4pCTHXCmlMYi3+TIfpjwmcUFBB8kE5ev0/ezsWzdCNUSSY3NGljZ1GR9mOgR/ReMuAp
	 V+fluhRLHDrnYo/pzY0n+7sD0B1eHo/yNU7UaKgyuDaoeoq6TyFDRapfdMEhXVq/d3uia
	 Y4/b+KIcp4nvp7JLHab6Z+ipnrb3zgl6cMc7ZTtMdBWssHV/D7qhT/6+Go7KG0Zl7yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083911;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=oENtBgDxQDILpdWFr9SR7q3ozaqUclSFojY+BQjWBhY=;
	b=yCV+XfqolpGvQyjhKpH3IVAkw8ef+sjnCvkw/+AC1evW0SxFy0XvemuH3WJLQJWaV82+
	 rxkMEPhUCSE0eokKYT5p4hfudUOBSDRsPSBy31L+v0sC9lygeIRrZWei7Oi/inO/WXCI1
	 efY7SFeUVpfL4IKoaJtSC9qTEArozR8tbrWSHe8O6VZwLI2efFfXH6nNHnnyNFNRJqQIq
	 MqZPNvAKfTyeoMiOUF3zCaOcxfhywnx4OsCaZHajxpNczg86esBadAndlkFpI23Os9JSR
	 AO8jVDVsc8beCv0GXPovCKJuYuhWf5c6kUonpgL4CuxZsJOSszP4tf/EXlVsJxa8M3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=NC1M5oxU;
	arc=none smtp.remote-ip=62.149.156.117
Received: from smtpcmd11117.aruba.it (smtpcmd11117.aruba.it [62.149.156.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B490606A330
	for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 10:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B490606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=NC1M5oxU
Received: from [192.168.0.186] ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TzKFxCnXp6VShTzKFxQr4y; Thu, 19 Nov 2026 11:25:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795083908; bh=Q9zJrZ0wXnXWsmyjv9s33EBa7YlKOzYgFTENm8dVngg=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=NC1M5oxUUNCSSCHGiwV892TMLdF959kGeURs1nrEkqaWyTLh6YvXuV+5yvDOQeMKO
	 fFjPL94Tw4hxZKRDpdib8mjHJncCTVsG0uppaf4Cs3SVx4chbIYxB/igZctOILjiDq
	 eUTsh+T/xYooLfuM7ik1u26dEmK6GKx4wTXf/dvQPERuk1wJlRyRxMcHo0IJhiuSC3
	 v1v1H8/3qKVWMuK6eZ1bKvIPE6n9SiKhZmXNUL4B0WRSVZTGePYhSJ7KKfzpeDK5We
	 ixCsNxJpFemu5sDF2dViPAT34arQ5nL9ss8RFi+haABojG1U2wzpx6s7bK/b16EKsE
	 LH+tkkZAMhwqA==
Message-ID: <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
Date: Thu, 19 Nov 2026 11:25:07 +0100
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
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Content-Language: en-US
To: florian.bauckholt@cispa.de, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
 Stefan Berger <stefanb@linux.ibm.com>, keyrings@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfFykGQACKRhov2XIilpQECvM/aNjmfh3eHVua/dfX0mTSaGmrnTrp8wSFXmi+91PsZSR3CNox52tQk7OthlCbvK81cCmNr2Bq+elt3dYE8UB6ypJlI5Y
 R6Za03zQGsoH9FMve8bmQSnfKS6L998MsYSHzy+1ZLB8G48Be8og32QffVafXX/6AhPy1H3Wf3A/Ja5hG0sgpDB/wEha7FfezD863t0w5oBfizJmIm0srYEr
 YHpuz8HGd8f6mzCTH1apwOsDitXAdAj9C6I0YqJgxY/zU2TkGQgk9mfZpi8QoYj0KOdpTUYD9+ByTCLD0cuaVpmQEQFj+pSrmpl2hgr0YYcJmj0DCTDHR5py
 3ec7oV1RE/duvtWRkdpC9VensJ3kFcZeUf2Tl4QWf+b45NgK8Hcy9StlAtigoYLQBdXKtWkZYnhN4ni1QYp8LtfKmBxIf34WD6EVfhqqVG66PoFMpbqLF0GW
 3zSCJGMaAT2QN8PtAAH1uuyRETQeK1nsQlHYZqkPM0WirdN0Y+1EvdCPrS2dPD4unRGPnZxbrPotroy1KkotYaoVu8+O2vKSsis5foc+s8QSheZTuR2Rd+Bl
 iRzq7ymBlkPzMZtH8Fx8SKFF+wtsUkWXKYZ/ormRZ96Cv8JAkkPTkRD2U9RwSwseEghc3s73XPXHaw3udkQmr/ZzaINMARjij7rhJsYhW7gzGfljLka7To7V
 5XwetE54oiYhcHLTlyBsNlQVPJWzubXg

On 19/11/2026 00:19, Florian Bauckholt via B4 Relay wrote:
> From: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> made keyctl_pkey_params_get_2() set params->out_len to the maximum
> output size of the operation instead of the size provided by the caller.
> It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> buffer: out_len shares a union with in2_len, the length of the
> signature.
> 
> As a result keyctl_pkey_verify() ignores the signature length passed by
> the caller and always reads max_sig_size bytes from the signature
> pointer. A shorter signature is extended with whatever follows it in
> the caller's memory, or the call fails with -EFAULT if that memory is
> not readable.
> 
> The x962 ECDSA template currently ignores data following a DER-encoded
> signature, which hides the problem there. A truncated RSA signature,
> however, is accepted if the bytes following it happen to match the ones
> that were cut off, as reported by Rodolfo Giometti [1].
> 
> Use the length provided by the caller, which has already been checked
> against max_sig_size.
> 
> Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> Link: https://lore.kernel.org/all/0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com/ [1]
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> ---
>  security/keys/keyctl_pkey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> index e7121523b9c9..722521a014ab 100644
> --- a/security/keys/keyctl_pkey.c
> +++ b/security/keys/keyctl_pkey.c
> @@ -175,7 +175,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>  			goto out_up_key_sem;
>  		}
>  
> -		params->out_len = info.max_sig_size;
> +		params->in2_len = uparams.in2_len;
>  		break;
>  	default:
>  		ret = -EOPNOTSUPP;
>

I ran test3008 of craf 2000 times on a UML kernel of current mainline
(666539eecdf4) with this change applied: no failures, against 4 out of
2000 without it.

Tested-by: Rodolfo Giometti <giometti@enneenne.com>

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
