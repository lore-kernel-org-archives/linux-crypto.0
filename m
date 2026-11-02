Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793578003;
	b=YfX3AOVHvqRjETMF6Li/xVlREa3CS/OTYNex7k5l7bC0iGJQe59DPKQ0dYHYVe0ZUE7L
	 5sQ+tSWwwvItL4edX+lIfAqwn3DeXdw7P0I2mwWls35dyxnZmGNnP7BRDwbAxf1TwcAyG
	 7ix5yM7eMkYE7sIVdVh7KI0EkwIOUB+OZhDavZqQ1RdX8pQrqO7baxDPb5CB7XwVWeI6Q
	 cHSEvCjP1N3aUSvsyC4xKwcvj8A01DMahTFfEW01ma8QhBjLld0bfX54APYODWX8ndW/J
	 jtzfV0jxmJAsObier8UrccptXOUSJXCpJH0sRLWqjqQlfTyBYV7YjoeCd2fzeEww+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793578003;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+SJEXO4zB7JFbzlAkf228If7IMH2rNzMGxDZgs6nB/Q=;
	b=JvhKY2uqXNCfgMva71xOKkgbJW2JaJ3gr4Z/KBMSvjB1+j2aOnuktJ6cspkIdyQZ1oyZ
	 ifE0F1s4zqWBCMZyBiZeEpsVzdvbfYbykr9xOUAXlzNINdgPWBL6rzLI5AQAN+BjovQcA
	 w5s1m0CMHtNgiYvOta1GOCZmZGY2DYogsm6zPnF6UCd5XF31YByiIWgUGqiFWfTRAK+KQ
	 ZlaCfFuUsRkbFDs3jUhCMkjtfXEjvy45Db0y4hn+n2+o0+S/7Q7JmFs+XpjdVUNvy2bZJ
	 ngYdiRmw19C+3H23UesY6PE8z+NHK/p80kFIRCgyTH5qmYbx2bQdT6mB+I3l5rlz4jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liqClC9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E0BAC606A324;
	Mon,  2 Nov 2026 00:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liqClC9W
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D32841F000C1;
	Mon,  2 Nov 2026 00:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793578002;
	bh=+SJEXO4zB7JFbzlAkf228If7IMH2rNzMGxDZgs6nB/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=liqClC9WWVGhUyktqyf5AnN22RgTBsT9tvLzLP54vGzkPCm0Mgi9EBUmEIzFo/0Qd
	 MnFohsjcxSRNP6ihrSlouq+TL92bQhXxANAH2lqBb3Qt+fzgNWjcisSmSrOvvEnwi5
	 g+BAF58QBCbxo5746rapXy+ndlJ3dLymq5k2DOfE+I2hPqq6Wg/B40EuhpD6XRer2C
	 /gogYorKDzvAC38OmYz9twt/tbyN9UQmOANe64JAzyMDCHsqvwywG9BryzVvAupd6e
	 mFwLHKk1m/hqihR9GI3BFNesiAceAaB7ui64sbvF8VQTNePKXFhY4/XfP8LHbIAyhW
	 DrfAN0zGzmKCg==
Date: Mon, 2 Nov 2026 02:06:39 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <aufUDyCKIBHnQtfR@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-2-jarkko@kernel.org>
 <20261101232213.GD2689@quark>
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
In-Reply-To: <20261101232213.GD2689@quark>

On Sun, Nov 01, 2026 at 03:22:13PM -0800, Eric Biggers wrote:
> On Fri, Oct 30, 2026 at 01:24:09AM +0200, Jarkko Sakkinen wrote:
> > Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
> > fs-verity how keyring internally manages the keys.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>

Thanks!

> 
> - Eric

Br, Jarkko
