From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/12] crypto: atmel-authenc: add support to
 authenc(hmac(shaX),Y(aes)) modes
Date: Fri, 3 Feb 2017 18:20:59 +0800
Message-ID: <20170203102059.GC2632@gondor.apana.org.au>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 26, 2017 at 05:07:45PM +0100, Cyrille Pitchen wrote:
> Hi all,
> 
> this series of patches has been based and tested on next-20170125 with
> CRYPTO_MANAGER_DISABLED_TESTS not set.
> 
> The series adds support to the hmac(shaX) algorithms first, then combines
> both the Atmel SHA and AES hardware accelerators to implement
> authenc(hmac(shaX),Y(aes)) algorithms as used by IPSEC/SSL connections.
> 
> It has also been tested with strongswan + xl2tpd to create an IPSEC+L2TP
> (transport mode) VPN and strongswan only (tunnel mode) for an IPSEC VPN.
> 
> Then iperf was used to measure the bandwidth improvement in tunnel mode:
> 
> drivers                                    AES SHA SPLIP iperf half-duplex
>                                                          Mbit/s
> authenc(hmac(sha1-generic),cbc(aes))        SW   SW  N/A 27.7
> authenc(hmac(sha1-generic),atmel-cbc-aes)   HW   SW  N/A 30.2 (mainline)
> authenc(atmel-hmac-sha1,atmel-cbc-aes)      HW   HW   no 29.1
> atmel-authenc-hmac-sha1-cbc-aes             HW   HW  yes 38.8
> 
> SPLIP: Secure Protocol Layers Improved Performances (AES+SHA combined).
> 
> Some patches of this series are purely transitional: I've split the
> modifications into many patches to ease the review.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
