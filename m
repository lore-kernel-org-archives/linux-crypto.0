From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/2] powerpc: Add module autoloading based on CPU features
Date: Tue, 19 Jul 2016 11:04:01 +1000
Message-ID: <13156.102030962$1468890422@news.gmane.org>
References: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
 <1468388840-12068-3-git-send-email-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
 linux-crypto@vger.kernel.org, Alastair D'Silva <alastair@d-silva.org>,
 linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: alastair@au1.ibm.com
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1468388840-12068-3-git-send-email-alastair@au1.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

YWxhc3RhaXJAYXUxLmlibS5jb20gd3JpdGVzOgoKPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBj
L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9jcHVm
ZWF0dXJlLmgKPiBuZXcgZmlsZSBtb2RlIDEwMDY0NAo+IGluZGV4IDAwMDAwMDAuLmRmMzE2MjcK
PiAtLS0gL2Rldi9udWxsCj4gKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2NwdWZlYXR1
cmUuaAo+IEBAIC0wLDAgKzEsNzAgQEAKPiArLyogQ1BVIGZlYXR1cmUgZGVmaW5pdGlvbnMgZm9y
IG1vZHVsZSBsb2FkaW5nLCB1c2VkIGJ5Cj4gKyAqIG1vZHVsZV9jcHVfZmVhdHVyZV9tYXRjaCgp
LCBzZWUgYXNtL2NwdXRhYmxlLmggZm9yIHBvd2VycGMgQ1BVIGZlYXR1cmVzCj4gKyAqCj4gKyAq
IENvcHlyaWdodCAyMDE2IEFsYXN0YWlyIEQnU2lsdmEsIElCTSBDb3Jwb3JhdGlvbi4KPiArICoK
PiArICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRl
IGl0IGFuZC9vcgo+ICsgKiBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZQo+ICsgKiBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdh
cmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24KPiArICogMiBvZiB0aGUgTGljZW5zZSwgb3Ig
KGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KPiArICovCj4gKwo+ICsjaWZuZGVm
IF9fQVNNX0NQVUZFQVRVUkVfSAo+ICsjZGVmaW5lIF9fQVNNX1BPV0VSUENfQ1BVRkVBVFVSRV9I
CgpUaG9zZSBzaG91bGQgbWF0Y2guIFRoZSBsYXR0ZXIgaXMgcHJlZmVycmVkLgoKY2hlZXJzCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4cHBjLWRl
diBtYWlsaW5nIGxpc3QKTGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9saXN0
cy5vemxhYnMub3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRldg==
