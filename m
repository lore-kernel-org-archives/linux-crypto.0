From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Tue, 11 Nov 2014 07:11:32 +0900
Message-ID: <20141110221132.GD20647@kroah.com>
References: <5460987C.9030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au,
	gmazyland@gmail.com, linux-crypto@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5460987C.9030007@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 10, 2014 at 11:50:36AM +0100, Ondrej Kozina wrote:
> Hello,
> 
> could you please add this patch (already landed in 3.18-rc1) to following
> stable kernels:
> 
> 3.17.x, 3.14.x, 3.12.x, 3.4.x, 3.2.x?
> 
> The bugfix allows usage of crypto API socket on archs with PAGE_SIZE >= 32
> KiB (I have a typo in original changelog).
> 
> Some background for the bug (with reproducer and report from users)
> - http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg11787.html
> - http://bugzilla.redhat.com/show_bug.cgi?id=1160289

Now applied to .17, .14, and .10-stable kernels, thanks.

greg k-h
