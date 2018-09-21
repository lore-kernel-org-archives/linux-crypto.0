From: Neil Armstrong <narmstrong@baylibre.com>
Subject: dm-integrity stalls with iMX6q CAAM
Date: Fri, 21 Sep 2018 14:06:35 +0200
Message-ID: <fbcca5eb-a301-53f4-3faf-a36a3229300d@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	horia.geanta@nxp.com, aymen.sghaier@nxp.com, dm-devel@redhat.com
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Hi,

I recently configured dm-crypt + dm-integrity on an iMX6q platform with CAAM Hash functions enabled using the following command lines :

Linux 4.14.71

cryptsetup luksFormat /dev/mmcblk1p3 --cipher aes-xts-plain64 --type luks2 --integrity hmac-sha256 --sector-size 512 --use-urandom
cryptsetup open /dev/mmcblk1p3 root
mkfs.ext4 -v -F /dev/mapper/root

luksFormat and open finishes correctly, luksDump and status reports correct dm and luks properties.

but when trying to access the /dev/mapper/root (mkfs, sha256sum or whatever), it blocks without any warning or errors reported by the kernel.
I can see a few (~170) interrupts on the jr0 interrupt then nothing.

Is there a particular issue with hmac-sha256 with the linux CAAM driver ?

When disabling the CAAM hash functions or using another cipher & integrity pair, it works like a charm.

Thanks,
Neil

-- 
Neil Armstrong
Embedded Linux Software Engineer
BayLibre - At the Heart of Embedded Linux
www.baylibre.com
