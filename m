Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092971;
	b=qGSq1VkNpZyyx+f1ljss3ayPR7y4YT5uGUSwzpqQAbT6Ir4l27z2PhBrSkaShLFffpBb
	 Im1hV9yPVUoSFrwEhrtcXVKMZptGLZ0BOaoXYjoGRMyt4oZl04LorPwzgpWU6B5gDOlmj
	 eqKWB7dJtwNgFop1/xgz7iHkZTziiV3EeVX3JcvezmAg/qbHNndv8Rvlia94LbUQU5E5r
	 Yp5tU/pFOsw+9QCXN3tMjw2KJjA60ofgxuOsdQdfa7SYNEel7Sk1tUr/FZ9LBmnJMS2L2
	 IqIcKlm6z8YH2OMh6Dt+Z0U8rHdJsw/puZNWKMSWXfQPhzpFakyQjk//R934y5JOdmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092971;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u2MLAZSC7Lrge7y5EMGWmll3Yf/qRKL/eAJllxB4zv4=;
	b=TfoCOxTfpDcDG0/GGY7vErEybG8mEJBXxu7HUXb4q6rnfKTPHa/w3ACQ3nkUvTLewxaA
	 DsDU4gp66jxPXm1Qd5QvA96UFa3P0r00mIZGFNdWgTxwcD6fa5mhvU2buCeiaAVpTJnq2
	 T1IwirHSPbyBEFCQMzWEihoN2Tnr8kqd/Ar4CVtURIi9xDcg38aNcra0oq9L5z+MSJ1wW
	 UdB9MNEfs8YyW7oMuXLs8PaEzhzZD3SNS2jg5YOd0lWuBU0MFCs7iy65ZpOOm1VpPHB0y
	 9P7VJQWlCQcvHVs5s+KRDieZerZE4oLwttSvLqD4y8iUKduZYPZELymHiIY5oQsBS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HwrPWC3B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B4A6D606A320;
	Thu, 19 Nov 2026 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HwrPWC3B
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C298E1F000C7;
	Thu, 19 Nov 2026 12:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092971;
	bh=u2MLAZSC7Lrge7y5EMGWmll3Yf/qRKL/eAJllxB4zv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HwrPWC3BSab+933wJQw/GlQUNcmXs89wCSQJc0FseJ5x5jmF9TVPGlMao2CjdQVEv
	 V7Cg20rmto5D76gtaOYLGbvKEMuwlPtQ5/xdILXL//6mbDi72cQTABQJCTvvIjiuV7
	 BVbpEdYTCQJWZ8KlqvfylA2r/eta85PEZ9IX0rov2fhQ3eK0B+n2349J56jXsgPdOm
	 vbQMTt+qcCLrqWV8eqNHQyP+TeV+ZDRpz+800lu58ssazIjp5unR+g7eF4kA56yy19
	 uFyjaJEwegG70OCnnQB8sM3mv1c7bu4ZpSEQxFgAhIjCXnryzX3+pGHU1QMYhDUdbp
	 GGSUmMiogGzyw==
Date: Thu, 19 Nov 2026 14:56:07 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: florian.bauckholt@cispa.de, David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <av7x53CigERu-cf2@kernel.org>
References: <20261119-keyctl-pkey-fixes-v2-0-9e2d1c7db7ec@cispa.de>
 <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80ded1ae-51a7-46d1-bb67-02b4b06de71b@enneenne.com>

On Thu, Nov 19, 2026 at 11:25:07AM +0100, Rodolfo Giometti wrote:
> On 19/11/2026 00:19, Florian Bauckholt via B4 Relay wrote:
> > From: Florian Bauckholt <florian.bauckholt@cispa.de>
> > 
> > Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> > made keyctl_pkey_params_get_2() set params->out_len to the maximum
> > output size of the operation instead of the size provided by the caller.
> > It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> > buffer: out_len shares a union with in2_len, the length of the
> > signature.
> > 
> > As a result keyctl_pkey_verify() ignores the signature length passed by
> > the caller and always reads max_sig_size bytes from the signature
> > pointer. A shorter signature is extended with whatever follows it in
> > the caller's memory, or the call fails with -EFAULT if that memory is
> > not readable.
> > 
> > The x962 ECDSA template currently ignores data following a DER-encoded
> > signature, which hides the problem there. A truncated RSA signature,
> > however, is accepted if the bytes following it happen to match the ones
> > that were cut off, as reported by Rodolfo Giometti [1].
> > 
> > Use the length provided by the caller, which has already been checked
> > against max_sig_size.
> > 
> > Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> > Link: https://lore.kernel.org/all/0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com/ [1]
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> > Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> > ---
> >  security/keys/keyctl_pkey.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> > index e7121523b9c9..722521a014ab 100644
> > --- a/security/keys/keyctl_pkey.c
> > +++ b/security/keys/keyctl_pkey.c
> > @@ -175,7 +175,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
> >  			goto out_up_key_sem;
> >  		}
> >  
> > -		params->out_len = info.max_sig_size;
> > +		params->in2_len = uparams.in2_len;
> >  		break;
> >  	default:
> >  		ret = -EOPNOTSUPP;
> >
> 
> I ran test3008 of craf 2000 times on a UML kernel of current mainline
> (666539eecdf4) with this change applied: no failures, against 4 out of
> 2000 without it.
> 
> Tested-by: Rodolfo Giometti <giometti@enneenne.com>

Thanks.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>


> 
> Ciao,
> 
> Rodolfo
> 
> -- 
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming

Br, Jarkko
