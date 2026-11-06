Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991607;
	b=NEx7VmJpVCkuxzSPXffFC6gJkUdPMIr18fn9pLUrOrnbaZJsjJO16kYWajMMsTf8F/P6
	 ll1mqx73A34J8ntGWADSF7DkCKWnsBqlW61GgkvtnYr+Y2cn6YutzdY+5sTJ5gNhv1KaO
	 EYtBJLEcLOcNg4PEOLjoaRsSrqOz5FwaPXa+8ldTjpes15fvTUxCoCgRp1tiwgpZgTwZY
	 oKrBHA3Bxs6BQnwpCqqWnAlvu+yxJjepxmhTYYncjeosey1FtsCzPJevVrW7C5zZheTyb
	 vTLE3DR3dgGmunY6azuzyqQRqhMpBTZIA1dddXpo6pB6WI3kqLDkoqr6wmsoUqbjlhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991607;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=uOUk0mG5r+SgoWX7aRafh4J2ITZ//eSF94S2lwXLaPw=;
	b=HeQ71Bxeb8xQPpHx5xS8XlSYlMfaLqkckXzu2jUYXjX3YJnyHIJqxQyrS7K7pRu2S4TL
	 x3qKOw8hBIg1ivuaCfkuojsFi44WXrGU2ze2fFveUrOYrsx+geNX9+zPsDBNnI7dzr5gU
	 dpO3GrVDDRmADSNF9wcrcWxTfScJ5jJ7ulwsBb1tJVcV/mtJeo5b0CPF3xSu7+Fby01o+
	 0c711J+iDlYbyu/vjT8KplamPcWS03iNcfqjttdo6SwHb//cynJ0a8DV5ZLBO9le6FYW4
	 kzIz08xjPhmwsqsOv29ox6x/xsUpKQCdqd+rxN+/olHPJPUx9JXo6Ycp62tXrzdxsAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQwh4m9h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 67A2A606A32D;
	Fri,  6 Nov 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQwh4m9h
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 76CDA1F0089F;
	Fri,  6 Nov 2026 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991607;
	bh=uOUk0mG5r+SgoWX7aRafh4J2ITZ//eSF94S2lwXLaPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IQwh4m9hNISCWCqJGObw3tNSNtIIdVaKp2O6yDGXbbyYonDrcJiSB1ixXCH6/oDVA
	 L/YHuHxP2oVoZuxguwRYkwTIXJ5k19WSrarYmQVxvDtS5UrTMeCIImuTwstVT8QZHP
	 z/14bBFWqijotc5s/LB2WfKtXwFi7IwO8DbisU7duHKytVzKdqZNUb4ShP3VPTIxR+
	 5UrVkgjp21U58j83f/PGOzaCY+JYvMF/sIIdPIPJqt5HyA4dy6riPwfhLwfKPicpj5
	 38yMdzR8eeS34I9ZtV9pIWflhy+5cRCvE4KZdSpLLNAbnrOcvwk5UO1mwCzWTizxLP
	 NhHlnxOIL+wqA==
Date: Fri, 6 Nov 2026 21:00:02 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ignat Korchagin <ignat@linux.win>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, Lukas Wunner <lukas@wunner.de>,
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
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>,
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>,
	"open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)" <bpf@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KEYS: Introduce keyring_is_empty()
Message-ID: <au4jsjwXP2JxEARl@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-2-jarkko@kernel.org>
 <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>

On Fri, Nov 06, 2026 at 06:29:56PM +0000, Ignat Korchagin wrote:
> On Thu, Oct 29, 2026 at 11:25 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
> > fs-verity how keyring internally manages the keys.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Reviewed-by: Ignat Korchagin <ignat@linux.win>

Thank you.

Br, Jarkko
