From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] splice: sendfile() at once fails for big files
Date: Wed, 06 May 2015 09:28:01 -0600
Message-ID: <554A3301.7010603@kernel.dk>
References: <20150506152648.396B31A235F@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	torvalds@linux-foundation.org, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150506152648.396B31A235F@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/06/2015 09:26 AM, Christophe Leroy wrote:
> Using sendfile with below small program to get MD5 sums of some files,
> it appear that big files (over 64kbytes with 4k pages system) get a
> wrong MD5 sum while small files get the correct sum.
> This program uses sendfile() to send a file to an AF_ALG socket
> for hashing.

Thanks, queued up for this series.

-- 
Jens Axboe
