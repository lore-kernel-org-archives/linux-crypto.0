From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 REPOST 0/6] fix hw_random stuck
Date: Mon, 22 Dec 2014 23:05:16 +1100
Message-ID: <20141222120515.GD21045@gondor.apana.org.au>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org, m@bues.ch, mpm@selenic.com,
	amit.shah@redhat.com
To: Amos Kong <akong@redhat.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 08, 2014 at 04:50:34PM +0800, Amos Kong wrote:
> When I hotunplug a busy virtio-rng device or try to access
> hwrng attributes in non-smp guest, it gets stuck.
> 
> My hotplug tests:
> 
> | test 0:
> |   hotunplug rng device from qemu monitor
> |
> | test 1:
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 2:
> |   guest) # dd if=/dev/random of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 4:
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   cat /sys/devices/virtual/misc/hw_random/rng_*
> |
> | test 5:
> |   guest) # dd if=/dev/hwrng of=/dev/null
> |   cancel dd process after 10 seconds
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 6:
> |   use a fifo as rng backend, execute test 0 ~ 5 with no input of fifo

All applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
