From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -stable] arm: crypto: reduce priority of bit-sliced AES
 cipher
Date: Sun, 19 Nov 2017 11:21:54 +0100
Message-ID: <20171119102154.GA12993@kroah.com>
References: <20171117195027.88288-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117195027.88288-1-ebiggers@google.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 17, 2017 at 11:50:27AM -0800, Eric Biggers wrote:
> Hi,
> 
> I'd like the following patch to be applied to stable for versions
> between 4.1 and 4.10 (inclusively).
> 
> This is a minimal fix for a bug where arm32 kernels can use a much
> slower implementation of AES than is actually available, potentially
> forcing vendors to disable encryption on their devices.
> 
> Min version is 4.1 because that was the first version to include the
> aes-ce algorithms.
> 
> Max version is 4.10 because in 4.11, this bug was fixed incidentally as
> part of a complete rewrite of the bit-sliced AES implementation.

Thanks for the patch, now queued up.

greg k-h
