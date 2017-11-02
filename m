From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 2/4] crypto: dh - don't permit 'p' to be 0
Date: Thu, 2 Nov 2017 13:40:51 +0200
Message-ID: <281c8d97-7d44-d157-5221-1487ec03a06f@microchip.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
 <20171101222517.41602-3-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <keyrings@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, <stable@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171101222517.41602-3-ebiggers3@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, Eric,

On 11/02/2017 12:25 AM, Eric Biggers wrote:
> If 'p' is 0 for the software Diffie-Hellman implementation, then
> dh_max_size() returns 0.

dh_set_secret() returns -EINVAL if p_len < 1536, see
dh_check_params_length(). What am I missing?

Cheers,
ta
