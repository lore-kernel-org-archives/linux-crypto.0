From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: x86: Remove duplicate define of SHA1_DIGEST_SIZE
Date: Fri, 16 Oct 2015 09:04:58 -0700
Message-ID: <1445011498.14635.1.camel@schen9-desk2.jf.intel.com>
References: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ameenali023@gmail.com, bp@alien8.de, dan.carpenter@oracle.com,
	davem@davemloft.net, firogm@gmail.com, herbert@gondor.apana.org.au,
	hpa@zytor.com, mingo@redhat.com, minipli@googlemail.com,
	smueller@chronox.de, tglx@linutronix.de, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-10-14 at 21:15 +0200, LABBE Corentin wrote:
> The sha x86 crypto code use two define for the same thing:
> NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
> Replace them by SHA1_DIGEST_SIZE/4

Thanks.  Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
