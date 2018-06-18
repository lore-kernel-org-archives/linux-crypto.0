From: Matt Corallo <linux@bluematt.me>
Subject: crypto-vmx fails to load fallbacks (missing dep?)
Date: Mon, 18 Jun 2018 15:28:07 -0400
Message-ID: <d98b4a54-e580-0b79-7094-e953c7134667@bluematt.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
 debian-kernel@lists.debian.org
To: linux-crypto@vger.kernel.org
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Content-Language: en-US
Resent-Message-ID: <ocXnz64oG0B.A._bG._0AKbB@bendel>
List-URL: <https://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/d98b4a54-e580-0b79-7094-e953c7134667@bluematt.me
List-Id: linux-crypto.vger.kernel.org

If crypto-vmx gets built-in (which the latest debian kernel configs in
git do, at least when you build them against 4.17.2) but you don't
build-in ghash/cbc/ctr/etc, you end up with dmesg lines like:

[    3.704126] Failed to allocate transformation for 'cbc(aes)': -2
[    3.704172] alg: skcipher: Failed to load transform for p8_aes_cbc: -2
[    3.706542] Failed to allocate transformation for 'ctr(aes)': -2
[    3.706605] alg: skcipher: Failed to load transform for p8_aes_ctr: -2
[    3.714095] Failed to allocate transformation for 'ghash-generic': -2
[    3.714162] alg: hash: Failed to load transform for p8_ghash: -2

(which I assume are a failure to load the fallback driver) and as a
result are never able to use aes-cbc/aes-ctr/ghash as crypto_alg_lookup
will fail the crypto_is_larval check and return ELIBBAD. When they're
all built-in everything seems to work fine.
