From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] crypto_user: Fix out-of-bounds read
Date: Wed, 23 Apr 2014 22:23:45 +0300
Message-ID: <20140423192345.GZ4963@mwanda>
References: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
 <20140423114039.GY4963@mwanda>
 <CALCETrXhY-XdAk_cUbQfVN2=2jx-6J3wX7DYMeAiML=VOhM+SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"security@kernel.org" <security@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXhY-XdAk_cUbQfVN2=2jx-6J3wX7DYMeAiML=VOhM+SA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 23, 2014 at 08:48:34AM -0700, Andy Lutomirski wrote:
> BUILD_BUG_ON(NLMSG_MIN_TYPE != CRYPTO_MSG_BASE) might be a better
> thing to add, then.

I don't have a strong opinion.

regards,
dan carpenter
