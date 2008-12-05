From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: des: fix inverted weak key flag check
Date: Fri, 05 Dec 2008 09:54:14 -0500
Message-ID: <49394096.6080402@redhat.com>
References: <200812041555.22429.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756400AbYLEOvV@vger.kernel.org>
In-Reply-To: <200812041555.22429.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jarod Wilson wrote:
> Based on the fact the testmgr code sets the weak key flag for
> vectors with wk = 1, the weak key flag check in des_setkey()
> is backwards. Also, add a warning when a weak key is rejected,
> otherwise you silently get a bogus result back.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Self-NAK. Due to mail server issues, this might show up before the 
original...

My understanding of the flag's meaning appears to be backwards, Herbert 
pointed out that the use of this flag is self-consistent. Also, the 
printk probably shouldn't be there, the caller should check retval and 
complain if need be.


-- 
Jarod Wilson
jarod@redhat.com
