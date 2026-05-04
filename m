Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35D53803DE;
	Mon,  4 May 2026 22:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777933525; cv=none; b=DFj20Zy0ZlbFWvO/Lrq725RBre85/mhhT9/IjsG9X7pjuGJV0I/FaKSJUBrM35Zs4PgqlFKpkY4PyZwstw7PrtnUOAtx3v3cFkijt0j1mHaMOHlipRak4/SnJxJJhnWl7kFd+iMFU1GlGq75B0hEERgNHVIApbeM62MoIAKeK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777933525; c=relaxed/simple;
	bh=CnZQLL+dBf/NVOi4BJkXDFBCc3w6j48on7waVvdGLNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1gvBLMNVmY/eNsdTC4Reijn93cJR94oVi9foy7tCKbLhbuMbn389C0Rw3iBgUCq7ATazO7NUXCgpbe57dl8dom/IoYZQI6wlP4bYFc9xBAYi+ifsWBfE7pnvS7KAQD5zNIJrnGtVTOiWkmFLHZTTpQHizbHof2x6jE+rYXcVtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6aUJxXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6aUJxXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B8CC2BCB8;
	Mon,  4 May 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777933525;
	bh=CnZQLL+dBf/NVOi4BJkXDFBCc3w6j48on7waVvdGLNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g6aUJxXpaDEy6WuqY8D1Hqtau12puytRPqAmeRKhLum++uSJCJLrneZ5Jm9zrH1zj
	 X9p5nBrVBx45tyy3h4erko45VteCnSCX4WDVhHPJNGfZN/EXV0B6/Od86fM3ZpqRtm
	 firrlkIo5V96g7Ocew5v7UZlL37qNayTPvjapwwzQZReHYgtOYZsgzTfhKjlV1LkEq
	 TgruHd2Lh9mXmIKIM/USPBJ926p7yFs1pKlPr3PS4W/0VP3lEZFGjSA3GJqMRGJpfC
	 ViZR01WgKLW2UY4vHGfNVCVzPPPTYbw+UsQ+g9fr2/lWRrnr7KXJOsqdDSR1Pa1ULE
	 HPVCvHGCAE3wA==
Date: Mon, 4 May 2026 15:25:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: =?utf-8?B?4pK2bMOvIFDimK5sYXRlbA==?= <alip@chesswob.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>,
	Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>,
	Tim Becker <tjbecker@theori.io>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Feng Ning <feng@innora.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
Message-ID: <20260504222518.GA21478@quark>
References: <20260504061532.172013-1-ebiggers@kernel.org>
 <mCm5pwZUNYtOVDph2baJg3eAzArddjvFpx3Wwh2qiZfZXYtv-aUjlISuRg5HjuIMzGo51hxCazaH47gp9B_q7I4R4LVePKGkvhO9D0P4nCY=@chesswob.org>
 <20260504174733.GB2291@sol>
 <xxEJMG_wLMObY-emZXfETJ6HxxJQCY3OnYiBIUTyAWEMiAcr8QQd2t7c8O-Qj43zBGRv64st0_IrW9ABgaVwco9-puLVlIDh3ijeJ-cxXaE=@chesswob.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xxEJMG_wLMObY-emZXfETJ6HxxJQCY3OnYiBIUTyAWEMiAcr8QQd2t7c8O-Qj43zBGRv64st0_IrW9ABgaVwco9-puLVlIDh3ijeJ-cxXaE=@chesswob.org>

On Mon, May 04, 2026 at 06:26:10PM +0000, Ⓐlï P☮latel wrote:
> On Monday, 4 May 2026 at 19:51, Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Mon, May 04, 2026 at 04:07:45PM +0000, Ⓐlï P☮latel wrote:
> > > Syd sandbox uses AF_ALG zero-copy for its Force Sandboxing[1] and Crypt Sandboxing[1].
> > > Zero-copy means Syd does not have to copy sandbox process data into its own address
> > > space providing safety and security. Switching to read/write rather than pipes and
> > > splice breaks a fundamental safety guarantee for the sandbox. Please do not break
> > > userspace.
> > >
> > > Will sendfile(2) continue to work?
> > >
> > > [1]: https://man.exherbo.org/syd.7.html#Force_Sandboxing
> > > [2]: https://man.exherbo.org/syd.7.html#Crypt_Sandboxing
> > 
> 
> > It's very unclear what that feature (which I don't think anyone knew
> > even existed) is trying to accomplish.  Regardless, this patch doesn't
> > break the splice or sendfile syscalls.  It just makes them run a bit
> > more slowly since the kernel will copy the data internally.  So I think
> > your concern isn't justified.
> > 
> 
> > > How can i test? Please help me.
> > 
> 
> > If this is a feature you care about, perhaps you know how to test it?
> 
> Thank you very much for the explanation and excuse me I panicked.
> 
> > - Eric

I've tested that all three cases of read/write, sendfile, and
vmsplice+splice still work.  The difference is just in how the kernel
implements them internally.  See the following test program.

#define _GNU_SOURCE
#include <assert.h>
#include <fcntl.h>
#include <linux/if_alg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/sendfile.h>
#include <sys/socket.h>
#include <unistd.h>

int main(void)
{
	for (int test = 0; test < 3; test++) {
		uint8_t msg[32] = {};
		uint8_t key[16] = {1,2,3,4};
		struct sockaddr_alg addr = {
			.salg_family = AF_ALG,
			.salg_type = "skcipher",
			.salg_name = "cbc(aes)",
		};
		int filefd, algfd, reqfd, pipefd[2], ret;

		filefd = open("msg_file", O_RDWR|O_CREAT|O_TRUNC, 0600);
		assert(filefd >= 0);
		ret = pwrite(filefd, msg, sizeof(msg), 0);
		assert(ret == sizeof(msg));

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		assert(algfd >= 0);
		ret = bind(algfd, (struct sockaddr *)&addr, sizeof(addr));
		assert(ret == 0);
		ret = setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, sizeof(key));
		assert(ret == 0);

		reqfd = accept(algfd, NULL, NULL);
		assert(reqfd >= 0);

		switch (test) {
		case 0:
			printf("read/write test\n");
			ret = read(filefd, msg, sizeof(msg));
			assert(ret == sizeof(msg));
			ret = write(reqfd, msg, sizeof(msg));
			assert(ret == sizeof(msg));
			break;
		case 1:
			printf("sendfile test\n");
			ret = sendfile(reqfd, filefd, NULL, sizeof(msg));
			assert(ret == sizeof(msg));
			break;
		case 2:
			printf("splice test\n");
			ret = pipe(pipefd);
			assert(ret == 0);
			struct iovec iov = { .iov_base = msg, .iov_len = sizeof(msg) };
			ret = vmsplice(pipefd[1], &iov, 1, SPLICE_F_GIFT);
			assert(ret == sizeof(msg));
			ret = splice(pipefd[0], NULL, reqfd, NULL, sizeof(msg), SPLICE_F_MOVE);
			assert(ret == sizeof(msg));
			break;
		}
		ret = read(reqfd, msg, sizeof(msg));
		assert(ret == sizeof(msg));
		for (int i = 0; i < sizeof(msg); i++)
			printf("%02x ", msg[i]);
		printf("\n");
	}
}
