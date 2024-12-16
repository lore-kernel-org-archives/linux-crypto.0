Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201BC207E0F;
	Mon, 16 Dec 2024 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734372157; cv=none; b=AuxWuLcQVfeG9B1yKdj9DcXXxmTqrrmGS4RxuqXl4EVwlHCGaTVVrBkRJExJtCq2Wx0JBv/2oNg5rZ9kLaDbVG3H+ZAMxZjmtzx9j8pjZvkP/hWyJGzbyTnc5I4+sWo1LvIn4nNYfq7MjyiojF8N+2535BmGo3HTLLgYRYu1xPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734372157; c=relaxed/simple;
	bh=BYL7gtBKoYQblBda99sA9+7q7d1xM9wctYWMyYI81Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=px97kPCMT9G2j6pRKp2NfnmyV/aamT54bwKlDOt4A+uXOoa6kd7Cvu45xpWTAt1dbhQUN7ExOKSBYRQilBNg7tqcll7IzdxydcGOzTVj/FdfG2bN7vTmVyB6zsVDmbfPgV12tEN7y1cDq0yw0cJMdlMmmI+ukXtjWuW9bZn8ZgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcJjjI6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcJjjI6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB49C4CED0;
	Mon, 16 Dec 2024 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734372156;
	bh=BYL7gtBKoYQblBda99sA9+7q7d1xM9wctYWMyYI81Bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mcJjjI6Ghvlk0KnH7D2qyIOxqP9WshJCWuXJdEEABvltTzt09XeBSaFSxsD71ejSR
	 R+ahMYy/FFZz4lEP746wp7FdxgqQmjCBSfYL9Net8TqXgX/6pxale7/x9sCHy+ZamT
	 l3e5ITjj7b9xw9FPqg8eibCgsWnHfSf2ZCXteH/66RKqP/sESa1LoZyzaN2G9XeaFz
	 nl59U+SPZ6ls7fzVHABpeHUrSTHHcZhL6GkLJtWnSMXnywW1YISnZZpFBKc5+0pvIx
	 kdtXo5WQ16xar2VnXf5wMHWxviwffZMXtV3l95By/0+VWK9w4bTcH/Dicjxq3pBbA6
	 uiq/EGTztm7fQ==
Date: Mon, 16 Dec 2024 11:02:31 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	clang-built-linux <llvm@lists.linux.dev>,
	thara gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: next-20241216: drivers/crypto/qce/sha.c:365:3: error: cannot
 jump from this goto statement to its label
Message-ID: <20241216180231.GA1069997@ax162>
References: <CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFRT=AGqmLSRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFRT=AGqmLSRA@mail.gmail.com>

Hi Naresh,

Thanks for the report.

+ Bartosz as author of ce8fd0500b74

On Mon, Dec 16, 2024 at 10:04:05PM +0530, Naresh Kamboju wrote:
> The arm and arm64 builds failed on Linux next-20241216 due to following
> build warnings / errors with clang-19 and clang-nightly toolchain.
> Whereas the gcc-13 builds pass.
> 
> arm, arm64:
>   * build/clang-19-defconfig
>   * build/clang-nightly-defconfig
> 
> First seen on Linux next-20241216.
>   Good: next-20241216
>   Bad:  next-20241213
> 
> Build log:
> -----------
<trimmed irrelevant warning>
> drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto
> statement to its label
>   365 |                 goto err_free_ahash;
>       |                 ^
> drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of
> variable with __attribute__((cleanup))
>   373 |         u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
>       |             ^
> 1 error generated.

It is a bug to jump over the initialization of a cleanup variable
because the cleanup function will be called on an uninitialized pointer
in those cases. GCC does not catch this at compile time like clang does
(it would be nice if we could document this somewhere and really
encourage people doing cleanup annotations to ensure their patches pass
a clang build except in architecture code where clang does not support
that target):

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91951

It may be worth just reverting commit ce8fd0500b74 ("crypto: qce - use
__free() for a buffer that's always freed") since it seems like little
value in this case but if we want to forward fix it, I think we could
just mirror what the rest of the kernel does and keep the declaration at
the top of the function and initialize the pointer to NULL. The diff
below resolves the issue for me, which I don't mind sending as a formal
patch.

Cheers,
Nathan

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index c4ddc3b265ee..e251f0f9a4fd 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -337,6 +337,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	struct scatterlist sg;
 	unsigned int blocksize;
 	struct crypto_ahash *ahash_tfm;
+	u8 *buf __free(kfree) = NULL;
 	int ret;
 	const char *alg_name;
 
@@ -370,8 +371,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 				   crypto_req_done, &wait);
 	crypto_ahash_clear_flags(ahash_tfm, ~0);
 
-	u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
-					GFP_KERNEL);
+	buf = kzalloc(keylen + QCE_MAX_ALIGN_SIZE, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto err_free_req;
