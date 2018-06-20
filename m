From: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Thu, 21 Jun 2018 07:12:47 +0900
Message-ID: <20180620221247.GA25379@randy-betty>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com>
 <20180620181051.GC76265@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620181051.GC76265@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 11:10:51AM -0700, Eric Biggers wrote:
> Also, can you describe the users of Skein in the kernel?  If there are no users,
> there's no need to move it out of staging, or even have it in the kernel at all
> anymore.  I say that as someone who has had to volunteer to fix critical bugs
> found by fuzzing in crypto algorithms for which it's unclear why they are in the
> kernel at all, as there are no apparent users.

To be honest I'm not aware of anyone actually using Skein.

So by this are you suggesting that we drop support? If not removed, I believe
it's better to use test vectors as regression tests for further modifications.

-- 
Juan Manuel Torres Palma
Computer Engineer
