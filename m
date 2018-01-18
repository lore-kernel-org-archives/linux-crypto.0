From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [BUG] skcipher: Test 1 failed (invalid result) on encryption for
	cts(virtio_crypto_aes_cbc)
Date: Thu, 18 Jan 2018 10:08:04 +0100
Message-ID: <20180118090804.GB1988@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux-foundation.org
To: mst@redhat.com, jasowang@redhat.com, arei.gonglei@huawei.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
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

Hello

When modprobing tcrypt on a qemu virtual machine, I get the following trace in dmesg:
skcipher: Test 1 failed (invalid result) on encryption for cts(virtio_crypto_aes_cbc)

Regards
Corentin Labbe
