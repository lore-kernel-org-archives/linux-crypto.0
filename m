Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793575337;
	b=bCPgwsMnjpwNlfMZW6ZiCS4CTShso515RRPM0jdWJE3PRTXyv8A0acAGyyvA0mNQu+NZ
	 6OtgPVwJuwhtlSf5oEAobix1Vt4KzeN31NXc4VFo22ETbdTN6H86XTdWxLlJFpJ0O1PUA
	 5P5BHBn8vieHDVGsFhwnVzwyTd6IeyklCFOkVIfwqs/KiLR9xXi+weaNpD9OdRgkilO4a
	 WO77ZzeBSpVXu9XIFi9ENEUC/hcxbgYaS4Cb38tVSkbH4WXp4RcMbJmzZ7Q3N62yz5TKW
	 7bZqpdZ84LhEFpiR9Zx6c+CkL42Q2tbZy4fuzY9JCxAfobkkvCJaXtwEEptWTkyCemQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793575337;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cgbnb2lThgPEeB3edRcUUe9u+jXneAUVV1o/2RJjGUg=;
	b=BfXEBh/oyd6dh3kAWyq6q/ln2VlhGpboujyhQnusoMk4kyt72y4Cpdbu4UCmGa4ctao7
	 pkhSevidpW5bpTp94N/aPw9sFlNXswgmAW5fh/8GX6dq9Ez40kOc1CakcuVf7bUnTbWM3
	 fNOmWa9d8NqvsykANvi47WD5TzGipJ+iBIeVdJZaySuDyMn+OwSLV0sui4Cv/LVU6Y55/
	 f+gywoEjWaBNEj6zgl/pe71ZZiFqv2/dgX50ELS8ZQZmYCKxMF6prAQBskVML7WnXjHyZ
	 SxGL1mx/o9l3itkqgWrDlqXX6ON2AffYkgvBhnSwGPSbER2vpBZTrPXStSfqEaWM21A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V+WwBx1l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7437F606A331;
	Sun,  1 Nov 2026 23:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V+WwBx1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060141F00A1A;
	Sun,  1 Nov 2026 23:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793575337;
	bh=cgbnb2lThgPEeB3edRcUUe9u+jXneAUVV1o/2RJjGUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V+WwBx1lCytCK5su6Mvuld4oik/2OI6WSVKfvjxF/44A1b/ncXlrxAh/K7++VF73S
	 STxStuqPRr37PS+KOuwiF/8LuLNN1ne+Srxl2kWLU3ssYzMdxfMh9itPCjitJI9+G2
	 mCOGWQ1thuvOi3rsuEMIam4Hri53NDY3G7L19Eu6Seb+BklJmRIF0t9dqNfAV5m4Yg
	 m46vy5Fk2IOmmGF0bpNwMYnXltKHU8WpncAJQsOsS2HdsW1x05SocT0/Re8dsTskJp
	 uL7w4F7kBxxydMy6Sy0+c/XP3kx9g++Pz0Q5Yi95GmW9lZHPLQhwpke+fDpij78ocs
	 mThJs245ojHMQ==
Date: Sun, 1 Nov 2026 15:22:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>,
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>,
	"open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)" <bpf@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KEYS: Introduce keyring_is_empty()
Message-ID: <20261101232213.GD2689@quark>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-2-jarkko@kernel.org>
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
In-Reply-To: <20261029232437.2581640-2-jarkko@kernel.org>

On Fri, Oct 30, 2026 at 01:24:09AM +0200, Jarkko Sakkinen wrote:
> Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
> fs-verity how keyring internally manages the keys.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
